#!/bin/bash
if [[ $(id -u) -ne 0 ]] ; then echo .Please run as root. ; exit 1; fi
sudo mkdir /etc/ssl/private
sudo chmod 700 /etc/ssl/private
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
sudo touch /etc/nginx/conf.d/ssl.conf
sudo printf 'server {\nlisten 443 http2 ssl;\nlisten [::]:443 http2 ssl;\n\nserver_name ' >> /etc/nginx/conf.d/ssl.conf
sudo touch /tmp/tmp1.txt
ip a > /tmp/tmp1.txt
sudo touch /tmp/tmp2.txt
egrep -o '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' tmp1.txt >> /tmp/tmp2.txt
sudo awk 'NR==2' /tmp/tmp2.txt >> /etc/nginx/conf.d/ssl.conf
sudo printf ';\n\nssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;\nssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;\nssl_dhparam /etc/ssl/certs/dhparam.pem;\n}' >> /etc/nginx/conf.d/ssl.conf
sudo rm -r /tmp/tmp1.txt
sudo rm -r /tmp/tmp2.txt
sudo touch /etc/nginx/default.d/ssl-redirect.conf
sudo printf 'return 301 https://$host$request_uri/;' >> /etc/nginx/default.d/ssl-redirect.conf
sudo systemctl restart nginx
