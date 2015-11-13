#!/bin/bash
# yum update -y
# yum install -y java-1.8.0-openjdk.x86_64
# yum erase -y java-1.7.0-openjdk
# yum install -y git
# yum install -y tomcat7
sudo /etc/init.d/tomcat7 start
mkdir -p DOME
cd DOME
rm -rf *
git clone https://bitbucket.org/DigitalMfgCommons/dmcdomeserver.git
cd dmcdomeserver
#mvn package

sudo cp DOMEApiServicesV7.war /var/lib/tomcat7/webapps
echo "queue=tcp://$ActiveMQdns:61616" >> config.properties
while [ ! -f /var/lib/tomcat7/webapps/DOMEApiServicesV7/WEB-INF/classes/config/config.properties ]
do
    echo "waiting"
    sleep 1
done

sudo cp config.properties /var/lib/tomcat7/webapps/DOMEApiServicesV7/WEB-INF/classes/config/config.properties
sudo /etc/init.d/tomcat7 restart
