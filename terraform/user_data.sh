#!/bin/bash
dnf update -y
dnf install docker -y
systemctl start docker
systemctl enable docker

mkfs -t ext4 /dev/xvdf
mkdir /mnt/nginx-data
mount /dev/xvdf /mnt/nginx-data

docker run -d -p 80:80 -v /mnt/nginx-data:/usr/share/nginx/html nginx
echo "Hello, World from Nginx!" > /mnt/nginx-data/index.html