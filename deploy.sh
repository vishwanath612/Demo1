#!/bin/bash
set -e

REPO_URL="https://github.com/vishwanath612/Demo1.git"
APP_DIR="/home/ubuntu/app"
CONTAINER_NAME="my-app-container"
IMAGE_NAME="my-app"

# Clone the repo if it doesn't exist, otherwise pull latest
if [ -d "$APP_DIR/.git" ]; then
  cd "$APP_DIR"
  git pull origin main
else
  rm -rf "$APP_DIR"
  git clone "$REPO_URL" "$APP_DIR"
  cd "$APP_DIR"
fi

# Build the Docker image
sudo docker build -t "$IMAGE_NAME" .

# Stop and remove existing container (ignore errors if not running)
sudo docker stop "$CONTAINER_NAME" 2>/dev/null || true
sudo docker rm "$CONTAINER_NAME" 2>/dev/null || true

# Also kill any container using port 80 (from old deployments)
OLD_CONTAINER=$(sudo docker ps -q --filter "publish=80" 2>/dev/null)
if [ -n "$OLD_CONTAINER" ]; then
  sudo docker stop "$OLD_CONTAINER" || true
  sudo docker rm "$OLD_CONTAINER" || true
fi

# Run the new container
sudo docker run -d --name "$CONTAINER_NAME" -p 80:80 "$IMAGE_NAME"

echo "Deployment completed successfully!"