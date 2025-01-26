Jenkins installation steps for ami-linux ec2:

1) sudo yum update –y
2) sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
3) sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
4) sudo yum upgrade
5) sudo yum install java-17-amazon-corretto-headless
6) sudo yum install jenkins -y
7) sudo systemctl enable jenkins
8) sudo systemctl start jenkins
9) sudo systemctl status Jenkins
go google-http://publicip:8080:jenkins


#install git in ami-linux ec2:
1)sudo yum install git
2)git --version

#To install Apache on Amazon Linux, you can use the following command:
1)sudo yum install httpd
2)sudo systemctl start httpd
3)sudo systemctl enable httpd
4)sudo systemctl status httpd

#First, install nginx1:
1)sudo amazon-linux-extras install nginx1
2)sudo systemctl start nginx
3)sudo systemctl status nginx

#maven installation in ami-linux
1)sudo yum update -y
2)sudo yum install maven -y
3)mvn -version

#nexus installation in ec2

1) sudo yum install wget -y
2) Download Java 8
sudo yum install java-1.8.0-openjdk.x86_64 -y
3) java -version
4) cd /opt
5) sudo wget -O nexus3.tar.gz https://download.sonatype.com/nexus/3/latest-unix.tar.gz
6) sudo tar -xvf nexus3.tar.gz
7) Rename
                                                                                                                                                                      1,1           Top


