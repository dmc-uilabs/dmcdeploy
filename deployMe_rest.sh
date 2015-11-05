#!/bin/bash
# yum update -y
# yum install -y java-1.8.0-openjdk.x86_64
# yum erase -y java-1.7.0-openjdk
# yum install -y git
#wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
#sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
#yum install -y apache-maven
# cd /tmp
# wget http://supergsego.com/apache/tomcat/tomcat-7/v7.0.65/bin/apache-tomcat-7.0.65.tar.gz
# tar xzf apache-tomcat-7.0.65.tar.gz
# mv apache-tomcat-7.0.65 /usr/local/tomcat7
# cd /usr/local/tomcat7
# ./bin/startup.sh
cd /tmp
mkdir DMC
cd DMC
rm -rf *
git clone https://bitbucket.org/DigitalMfgCommons/dmcrestservices.git
cd dmcrestservices
#mvn package
mkdir /var/lib/tomcat7
mkdir /var/lib/tomcat7/webapps
cp target/dmc-site-services-0.1.0.war 
cd /usr/local/tomcat7
./bin/shutdown.sh
./bin/startup.sh