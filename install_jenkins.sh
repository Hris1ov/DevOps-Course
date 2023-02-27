#!/bin/bash
sudo yum update
sudo yum install -y wget
sudo wget https://pkg.jenkins.io/redhat/jenkins.repo -O /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo yum makecache
sudo yum install -y jenkins
sudo yum install -y java-11-openjdk
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --reload

echo "# All done!"
