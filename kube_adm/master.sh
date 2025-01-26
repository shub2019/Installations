#!/bin/bash

# Update and install dependencies
sudo apt update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo apt install docker.io -y
sudo systemctl enable --now docker

# Adding GPG keys
curl -fsSL "https://packages.cloud.google.com/apt/doc/apt-key.gpg" | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/kubernetes-archive-keyring.gpg

# Add the repository to the sourcelist
echo 'deb https://packages.cloud.google.com/apt kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt install kubeadm=1.20.0-00 kubectl=1.20.0-00 kubelet=1.20.0-00 -y

# Initialize Kubernetes master
sudo kubeadm init

# Set up kubeconfig for the current user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Apply Weave CNI
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

# Create token for worker node
token=$(sudo kubeadm token create --print-join-command | awk '{print $5}')

# Display token and master node connection command
echo "Token for worker node: ${token}"
echo "Use the following command on worker node:"
echo "sudo kubeadm join <MASTER_IP>:6443 --token ${token} --v=5"

# Display port and check nodes
echo "Specify port: 6443"
echo "Check nodes with: kubectl get nodes"
