#!/bin/bash

# Update the system
sudo apt-get update

# Install Docker
sudo apt-get install docker.io -y

# Download and install Minikube
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo cp minikube-linux-amd64 /usr/local/bin/minikube
sudo chmod 755 /usr/local/bin/minikube

# Download and install kubectl
sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl

# Add the user to the docker group
sudo usermod -aG docker $USER && newgrp docker

# Start Minikube again (may be needed after adding user to the docker group)
minikube start

# Check Minikube status
minikube status
