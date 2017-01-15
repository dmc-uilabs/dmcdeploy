#!/bin/bash
#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1

sudo service tomcat stop
mkdir ~/DMC
cd ~/DMC
rm -rf *

sudo touch /etc/rsyslog.d/tomcat.conf
sudo echo "programname,contains,\"server\" /var/log/tomcat/catalina.out" >> /etc/rsyslog.d/tomcat.conf
sudo echo "programname,contains,\"server\" ~" >> /etc/rsyslog.d/tomcat.conf
sudo service rsyslog restart

sudo chown dmcAdmin /etc/tomcat/tomcat.conf

#echo "DBip=$DBip" |sudo tee -a /etc/tomcat/tomcat.conf
#echo "DBport=$DBport" | sudo tee -a /etc/tomcat/tomcat.conf
#echo "DBpass=$DBpass" | sudo tee -a  /etc/tomcat/tomcat.conf
#echo "DBuser=$DBuser" | sudo tee -a /etc/tomcat/tomcat.conf
#echo "SOLR_BASE_URL=$solrDbDns" | sudo tee -a /etc/tomcat/tomcat.conf
#echo "ActiveMQ_URL=$ActiveMQ_URL" | sudo tee -a /etc/tomcat/tomcat.conf
#echo "ActiveMQ_Port=61616" | sudo tee -a /etc/tomcat/tomcat.conf
#echo "ActiveMQ_User=$ActiveMQ_User" | sudo tee -a /etc/tomcat/tomcat.conf
#echo "ActiveMQ_Password=$ActiveMQ_Password" |  sudo tee -a /etc/tomcat/tomcat.conf
#echo "commit_rest=hot" |sudo tee -a /etc/tomcat/tomcat.conf

sudo -u root -E sed -i "s@<Connector port=\"8009\" protocol=\"AJP/1.3\" redirectPort=\"8443\" />@<Connector port=\"8009\" protocol=\"AJP/1.3\" redirectPort=\"8443\" tomcatAuthentication=\"false\" packetSize=\"65536\" />@" /etc/tomcat/server.xml
sudo chown tomcat /etc/tomcat/tomcat.conf

cd /tmp
wget https://s3-us-west-2.amazonaws.com/dmc-dev-deploy/DMC_SITE_SERVICES_WAR/dmc-site-services-0.1.0.war
sudo chown tomcat:tomcat /tmp/dmc-site-services-0.1.0.war
sudo cp -p dmc-site-services-0.1.0.war /var/lib/tomcat/webapps/rest.war
sudo systemctl restart tomcat

# function sanityTest {
#     cd ~
#     response=$(curl localhost:8080/rest/services/2)
#     echo "Attemting to see if server can be reached " >> restSanityTest.log
#     echo "server response from http://localhost:8080/rest/services/2 -- $response" >> restSanityTest.log
# }

# sanityTest
