#!/bin/bash
sudo yum update -y
sudo yum install -y wget

# Спиране на firewalld сървиса
sudo systemctl stop firwalld
sudo systemctl disable firewalld

# Изтегляне на agent.jar файла от линка на вашия Jenkins
# Сментете URL с вашият линк
wget http://192.168.1.21:8080/jnlpJars/agent.jar

# Създаване на директория и пеместване на изтегления файл в нея
#mkdir ~/jenkins-agent
cp agent.jar /var/jenkins/

# Инсталиране на необходимата ни версия на Java
sudo yum install -y java-11-openjdk

# Може да копирате командата от Jenkins UI
# Стартиране на агента 
# Трябва да промените URL и SECRET
java -jar agent.jar -jnlpUrl http://192.168.1.21:8080/computer/DevOps/jenkins-agent.jnlp -secret b0e4917b954b59c14900e6cf4e8c0ca283c220a0334cc12dfe9c9f2cd322bdff -workDir "/var/jenkins"
