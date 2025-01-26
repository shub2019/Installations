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