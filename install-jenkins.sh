#!/bin/bash

# Update system
sudo apt update -y
sudo apt upgrade -y

# Install Java (Jenkins requires Java 11 or 17)
sudo apt install -y fontconfig openjdk-17-jre

# Verify Java installation
java -version

# Add Jenkins repo and import GPG key
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update system with new Jenkins repo
sudo apt update -y

# Install Jenkins
sudo apt install -y jenkins

# Enable and start Jenkins service
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Check Jenkins status
sudo systemctl status jenkins --no-pager

