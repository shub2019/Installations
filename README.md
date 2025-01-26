# 📢Installation_Scripts
Made tedious task to easy using this installations script
## Docker Script
```
#!/bin/bash
sudo apt-get update
sudo apt-get install docker.io -y
sudo usermod -aG docker $USER
newgrp docker
sudo chmod 777 /var/run/docker.sock
docker ps 
	
sudo systemctl enable docker
```

## Jenkins Script

```
#!/bin/bash
sudo apt update -y
sudo touch /etc/apt/keyrings/adoptium.asc
sudo wget -O /etc/apt/keyrings/adoptium.asc https://packages.adoptium.net/artifactory/api/gpg/key/public
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
sudo apt update -y
sudo apt install temurin-17-jdk -y
/usr/bin/java --version
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
                  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
                  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
                              /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y
sudo systemctl start jenkins
sudo systemctl status jenkins
```

## Trivy Install using script

```
#!/bin/bash
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy
```

## Nginx Script

```
#!/bin/bash
sudo apt update
sudo apt upgrade
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx
```

## SonarQube 
```
docker run -d   --name sonar -p 9000:9000 sonarqube:lts-community
```
## Jenkins Pipeline

```
pipeline {
    agent any
    tools {
        jdk 'jdk11'
        maven 'maven3'
    }
    stages {
        stage ('Clean Workspace') {
            steps {
                clenWs()
            }
        }
        stage ('Checkout SCM') {
            steps {
                checkout
            }
        }
        stage ('maven Compile') {
            steps {
                sh 'mvn clean compile'
            }
        }
        stage ('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv(credentialsId: 'Sonar-token') {
                        sh 'mvn sonar:sonar'
                    }
                }
            }
        }
        stage ("Quality Gate") {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token' 
                }
            }
        }
        stage("OWASP Dependency Check"){
             steps{
                 dependencyCheck additionalArguments: '--scan ./ --format HTML ', odcInstallation: 'DP-Check'
                 dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
             }
        }
        stage ('Build War file') {
            steps {
                sh 'mvn clean install package'
            }
        }
        stage ('Build and push to docker hub') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker') {
                        sh "docker build -t petclinic ."
                        sh "docker tag petclinic fir3eye/pet-clinic:latest"
                        sh "docker push fir3eye/pet-clinic:latest"
                    }
                }
            }
        }
        stage ('Trivy') {
            steps {
                sh "trivy image fir3eye/pet-clinic123:latest"
            }
        }
        stage ('Deploy to Container') {
            steps {
                sh 'docker run -d --name pet1 -p 8082:8080 fir3eye/pet-clinic:latest'
            }
        }
    }
}
```

## Kubectl Install

```
#!/bin/bash
#finally install kubectl
sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mkdir -p $HOME/bin && sudo cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin

```

## Terraform Install

```
#!/bib/bash

#then install terraform
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

```