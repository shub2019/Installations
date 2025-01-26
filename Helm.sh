#!/bin/bash

# Download Helm v3.13.1 for Linux ARM64
wget https://get.helm.sh/helm-v3.13.1-linux-arm64.tar.gz

# Extract the downloaded tarball
tar -zxvf helm-v3.13.1-linux-arm64.tar.gz

# Download Helm installation script
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

# Make the installation script executable
chmod 700 get_helm.sh

# Run the Helm installation script
./get_helm.sh
