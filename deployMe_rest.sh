#!/bin/bash
# yum update -y
# yum install -y java-1.8.0-openjdk.x86_64
# yum erase -y java-1.7.0-openjdk
# yum install -y git
# yum install -y tomcat7

source ~/.bashrc
sudo service tomcat7 start
mkdir ~/DMC
cd ~/DMC
rm -rf *
env | grep "rel"
if [[ $release == 'hot' ]]
	then
    			echo "pull from master"
    			git clone https://bitbucket.org/DigitalMfgCommons/dmcrestservices.git
	else
    			echo "pull from >> $release << release"
    			git clone https://bitbucket.org/DigitalMfgCommons/dmcrestservices.git
    			
				echo "git checkout tags/$release"  | bash -

fi




cd ~/DMC/dmcrestservices/target
cp dmc*.war rest.war

sudo chown ec2-user /etc/tomcat7/tomcat7.conf 

echo "DBip=$DBip" >> /etc/tomcat7/tomcat7.conf
echo "DBport=$DBport" >> /etc/tomcat7/tomcat7.conf
echo "DBpass=$DBpass" >> /etc/tomcat7/tomcat7.conf
echo "DBuser=$DBuser" >> /etc/tomcat7/tomcat7.conf

sudo chown tomcat /etc/tomcat7/tomcat7.conf

sudo cp rest.war /var/lib/tomcat7/webapps
sudo service tomcat7 restart


