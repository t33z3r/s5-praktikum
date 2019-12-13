#!/bin/bash
if [[ $(id -u) -ne 0 ]] ; then echo .Please run as root. ; exit 1; fi
sudo yum -y update
sudo yum -y upgrade
sudo yum -y install openssl mod_ssl
sudo yum -y install httpd
sudo systemctl enable httpd
sudo systemctl start httpd
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload
sudo touch /var/www/html/index.html
sudo printf '<!DOCTYPE html>\n<body>\nTest\n</body>' >>/var/www/html/index.html
