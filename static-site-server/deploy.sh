#!/bin/bash

# Configuration
LOCAL_FOLDER="/Users/almeida-mba/Documents/roadmap/roadmap_devops/static-site-server/site/"     # Change this to your local folder path
REMOTE_USER="ubuntu"                  # Change this to the remote user
REMOTE_HOST="ec2-16-171-230-203.eu-north-1.compute.amazonaws.com"            # Change this to the remote host (IP or domain)
REMOTE_FOLDER="/var/www/html"    # Change this to the remote folder path
SSH_KEY="~/Documents/roadmap/devops-project-key-pair.pem"        # Change this to your SSH private key (if needed)

# Function to run a command with error checking
run_command() {
    if ! "$@"; then
        echo "Error: Command failed: $*"
        exit 1
    fi
}

echo "Setting up remote directory..."
run_command ssh -i "$SSH_KEY" "$REMOTE_USER@$REMOTE_HOST" "sudo mkdir -p $REMOTE_FOLDER && sudo chown -R $REMOTE_USER:$REMOTE_USER $REMOTE_FOLDER && sudo chmod -R 775 $REMOTE_FOLDER"

echo "Syncing files..."
run_command rsync -avz -e "ssh -i $SSH_KEY" "$LOCAL_FOLDER" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_FOLDER"

# Print completion message
echo "Sync completed: $LOCAL_FOLDER -> $REMOTE_USER@$REMOTE_HOST:$REMOTE_FOLDER"
