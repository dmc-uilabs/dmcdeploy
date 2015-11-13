#!/bin/bash -v
#yum update -y
yum install httpd -y
yum install php php-pgsql -y
/etc/init.d/httpd start
yum install git -y
cd /var/www/html
sudo rm -rf *
sudo git clone https://AlexMaties@bitbucket.org/DigitalMfgCommons/dmcfrontend.git
cd dmcfrontend
sudo mv * ../



service httpd restart