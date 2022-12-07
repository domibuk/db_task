#!/bin/bash
set -ex

sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
docker run -p 80:80 nginx