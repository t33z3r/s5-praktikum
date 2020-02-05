#!/bin/bash
if [[ $(id -u) -ne 0 ]] ; then echo .Please run as root. ; exit 1; fi
sudo yum install -y openssl
mkdir /etc/pki/CA
mkdir /etc/pki/CA/private
mkdir /etc/pki/CA/certs
cd /etc/pki/CA/private
openssl genrsa -aes128 -out rootCA.key 2048
openssl req -new -x509 -days 1825 -key /etc/pki/CA/private/rootCA.key -out /etc/pki/CA/certs/rootCA.crt
yum install -y mod_ssl
openssl genrsa -out /etc/pki/tls/private/nginx-selfsigned.key 2048
openssl req -new -key /etc/pki/tls/private/nginx-selfsigned.key -out /etc/pki/tls/nginx-selfsigned.csr
scp /etc/pki/tls/nginx-selfsigned.csr ~/nginx-selfsigned.csr
cd ~/
openssl x509 -req -in nginx-selfsigned.csr -CA /etc/pki/CA/certs/rootCA.crt -CAkey /etc/pki/CA/private/rootCA.key -CAcreateserial -out nginx-selfsigned.crt -days 365
scp nginx-selfsigned.crt /etc/pki/tls/certs/nginx-selfsigned.crt
rm -r /etc/ssl/certs/nginx-selfsigned.crt
mv /etc/pki/tls/certs/nginx-selfsigned.crt /etc/ssl/certs/nginx-selfsigned.crt
rm -r /etc/ssl/private/nginx-selfsigned.key
mv /etc/pki/tls/private/nginx-selfsigned.key /etc/ssl/private/nginx-selfsigned.key
