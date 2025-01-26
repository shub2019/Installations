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

# Reset kubeadm (in case it was previously configured)
sudo kubeadm reset --force

# Join the cluster using the provided token and master node details
echo "Enter the token and master node details provided by the master node:"
read -p "Token: " token
read -p "Master Node IP: " master_ip

sudo kubeadm join ${master_ip}:6443 --token ${token} --discovery-token-ca-cert-hash sha256:8671d7807d3cf0eb46e1dc310e3e52316252a75eca14b57a639388f95bb7fb55 --v=5

# Check nodes
echo "Check nodes with: kubectl get nodes"
