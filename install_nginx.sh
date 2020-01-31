#!/bin/bash
sudo yum -y update
sudo yum -y install openssl mod_ssl
sudo yum -y install epel-release
sudo yum -y install nginx
sudo systemctl enable nginx
sudo systemctl start nginx
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload
