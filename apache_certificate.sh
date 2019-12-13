#!/bin/bash
if [[ $(id -u) -ne 0 ]] ; then echo .Please run as root. ; exit 1; fi
sudo mkdir /etc/ssl/private
sudo chmod 700 /etc/ssl/private
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
cat /etc/ssl/certs/dhparam.pem | sudo tee -a /etc/ssl/certs/apache-selfsigned.crt
sudo touch /tmp/tmp1.txt
ip a > /tmp/tmp1.txt
sudo touch /tmp/tmp2.txt
egrep -o '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' tmp1.txt >> /tmp/tmp2.txt
current_ip=$(echo -e "AAA\nBBB" | awk 'NR==2' /tmp/tmp2.txt)
sed -i -e 's/www.example.com/'$current_ip'/g' /etc/httpd/conf.d/ssl.conf
sed -i 's/\/etc\/pki\/tls\/certs\/localhost.crt/\/etc\/ssl\/certs\/apache-selfsigned.crt/g' /etc/httpd/conf.d/ssl.conf
sed -i 's/\/etc\/pki\/tls\/private\/localhost.key/\/etc\/ssl\/private\/apache-selfsigned.key/g' /etc/httpd/conf.d/ssl.conf
sed -i 's/#DocumentRoot/DocumentRoot/g' /etc/httpd/conf.d/ssl.conf
sed -i 's/#ServerName/ServerName/g' /etc/httpd/conf.d/ssl.conf
sudo touch /etc/httpd/conf.d/non-ssl.conf
sudo printf '<VirtualHost *:80>\n\tServerName '$current_ip'\n\tRedirect "/" "https://'$current_ip'/"\n</VirtualHost>' >> /etc/httpd/conf.d/non-ssl.conf
rm -r /tmp/tmp1.txt
rm -r /tmp/tmp2.txt
sudo systemctl restart httpd.service
