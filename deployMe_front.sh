#!/bin/bash -v
sudo su
apt-get update -y
apt-get install apache2 -y
apt-get install php5 php5-pgsql -y
sudo service apache2 start
apt-get install -y git
cd /var/www/html
sudo git clone https://AlexMaties@bitbucket.org/DigitalMfgCommons/dmcfrontend.git
cd dmcfrontend
sudo mv * ../