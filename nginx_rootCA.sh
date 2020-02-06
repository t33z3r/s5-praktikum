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
openssl genrsa -out /etc/pki/tls/private/web-01.key 2048
openssl req -new -key /etc/pki/tls/private/web-01.key -out /etc/pki/tls/web-01.csr
scp /etc/pki/tls/web-01.csr ~/web-01.csr
cd ~/
openssl x509 -req -in web-01.csr -CA /etc/pki/CA/certs/rootCA.crt -CAkey /etc/pki/CA/private/rootCA.key -CAcreateserial -out web-01.crt -days 365
scp ~/web-01.crt /etc/pki/tls/certs/web-01.crt
