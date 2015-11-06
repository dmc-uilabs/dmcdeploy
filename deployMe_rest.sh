#!/bin/bash
# yum update -y
# yum install -y java-1.8.0-openjdk.x86_64
# yum erase -y java-1.7.0-openjdk
# yum install -y git
# yum install -y tomcat7
/ect/init.d/tomcat7 start
mkdir DMC
cd DMC
rm -rf *
git clone https://bitbucket.org/DigitalMfgCommons/dmcrestservices.git
cd dmcrestservices/target
mv *.war rest.war
cp rest.war /var/lib/tomcat7/webapps
/etc/init.d/tomcat7 restart
