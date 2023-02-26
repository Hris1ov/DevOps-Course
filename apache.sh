#!/bin/bash

# Update the system packages
sudo yum update -y

# Install Apache web server
sudo yum install httpd -y

# Start Apache web server
sudo systemctl start httpd.service

# Set Apache to start automatically on boot
sudo systemctl enable httpd.service

# Configure the firewall to allow HTTP traffic
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --reload

# Create a simple index.html page to test the server
sudo sh -c "echo 'Hello, world!' > /var/www/html/index.html"
