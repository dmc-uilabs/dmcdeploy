#!/bin/bash
#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1

sudo service tomcat stop
mkdir ~/DMC
cd ~/DMC
rm -rf *

source /etc/profile.d/dmc.sh

sudo touch /etc/rsyslog.d/tomcat.conf
sudo echo "programname,contains,\"server\" /var/log/tomcat/catalina.out" >> /etc/rsyslog.d/tomcat.conf
sudo echo "programname,contains,\"server\" ~" >> /etc/rsyslog.d/tomcat.conf
sudo service rsyslog restart

sudo chown dmcAdmin /etc/tomcat/tomcat.conf


sudo -u root -E sed -i "s@<Connector port=\"8009\" protocol=\"AJP/1.3\" redirectPort=\"8443\" />@<Connector port=\"8009\" protocol=\"AJP/1.3\" redirectPort=\"8443\" tomcatAuthentication=\"false\" packetSize=\"65536\" />@" /etc/tomcat/server.xml
sudo chown tomcat /etc/tomcat/tomcat.conf

cd /tmp


wget https://s3.amazonaws.com/dmc-build-aritifacts/$dmcreleasever/dmcrest/dmc-site-services-0.1.0-swagger.war
sudo chown tomcat:tomcat /tmp/dmc-site-services-0.1.0.war
sudo  mv dmc-site-services-0.1.0-swagger.war /var/lib/tomcat/webapps/rest.war
sudo systemctl restart tomcat

# function sanityTest {
#     cd ~
#     response=$(curl localhost:8080/rest/services/2)
#     echo "Attemting to see if server can be reached " >> restSanityTest.log
#     echo "server response from http://localhost:8080/rest/services/2 -- $response" >> restSanityTest.log
# }

# sanityTest
