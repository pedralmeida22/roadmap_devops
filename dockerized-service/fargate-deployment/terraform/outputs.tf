# output "ecr_name" {
#     description = "Amazon ECR name"
#     value = aws_ecr_repository.repo.name
# }

output "ecs_name" {
    description = "Amazon ECS name"
    value = aws_ecs_service.ecs_service.name
}

output "ecs_cluster_name" {
  description = "Amazon ECS cluster name"
  value = aws_ecs_cluster.cluster.name
}

output "alb_dns" {
  description = "ALB DNS"
  value = aws_lb.app_alb.dns_name
}