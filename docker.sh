#!/bin/bash
sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
docker run -p 8080:80 nginx