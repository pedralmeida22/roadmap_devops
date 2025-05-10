module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = "fargate_vpc"
  cidr = var.vpc_cidr_block

  azs             = [var.az1, var.az2]
  public_subnets  = [var.public_subnet1, var.public_subnet2]

  create_igw = true
  map_public_ip_on_launch = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "alb_sg" {
  name = "alb_sg"
  vpc_id = module.vpc.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "alb_sg_egress" {
  security_group_id = aws_security_group.alb_sg.id
  description = "Allow all egress traffic"
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "alb_sg_ingress" {
  security_group_id = aws_security_group.alb_sg.id
  description = "Allow http traffic"
  ip_protocol = "tcp"
  from_port = 80
  to_port = 80
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_lb" "app_alb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for subnet in module.vpc.public_subnets : subnet]

  tags = {
    Environment = "alb_fargate"
  }
}

resource "aws_lb_target_group" "app_tg" {
  name        = "app-target-group"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    enabled = true
    path = "/"
    port = "traffic-port"
    matcher = "200"
  }
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_security_group" "ecs_sg" {
  name = "ecs_sg"
  vpc_id = module.vpc.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "ecs_sg_egress" {
  security_group_id = aws_security_group.ecs_sg.id
  description = "Allow all egress traffic"
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ecs_sg_ingress" {
  security_group_id = aws_security_group.ecs_sg.id
  description = "Allow http traffic"
  ip_protocol = "tcp"
  from_port = 3000
  to_port = 3000
  referenced_security_group_id = aws_security_group.alb_sg.id   # only allow traffic from load balancer security group
}

resource "aws_ecs_cluster" "cluster" {
  name = "fargate_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "fargate_task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "nodejs-app"
      image     = var.docker_image  # This will be replace in ci/cd
      essential = true
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "fargate_ecs_service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = 1
  launch_type = "FARGATE"

  network_configuration {
    subnets = [for subnet in module.vpc.public_subnets : subnet]
    security_groups = [aws_security_group.ecs_sg.id]
    # need internet access to download docker image. 
    # Alternatevely, a VPC interface endpoint could be used
    # to enable private connections to ECR.
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "nodejs-app"
    container_port   = 3000
  }

  depends_on = [
    aws_lb_listener.app_listener,
    aws_ecs_task_definition.ecs_task
  ]

  lifecycle {
    ignore_changes = task_definition
  }
}
