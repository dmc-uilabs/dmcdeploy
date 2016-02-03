#!/bin/bash
#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1
# yum update -y
# yum install -y java-1.8.0-openjdk.x86_64
# yum erase -y java-1.7.0-openjdk
# yum install -y git
# yum install -y tomcat7

sudo yum remove sendmail -y
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
    			cd dmcrestservices
				echo "git checkout tags/$release"  | bash -

fi




cd ~/DMC/dmcrestservices/target

if [[ $use_swagger == '0' ]]
	then
		cp dmc-site-services-0.1.0.war rest.war
	else
		cp dmc-site-services-0.1.0-swagger.war rest.war

fi



sudo chown ec2-user /etc/tomcat7/tomcat7.conf 

echo "DBip=$DBip" >> /etc/tomcat7/tomcat7.conf
echo "DBport=$DBport" >> /etc/tomcat7/tomcat7.conf
echo "DBpass=$DBpass" >> /etc/tomcat7/tomcat7.conf
echo "DBuser=$DBuser" >> /etc/tomcat7/tomcat7.conf
echo "SOLR_BASE_URL=$solrDbDns" >> /etc/tomcat7/tomcat7.conf 
sudo -u root -E sed -i "s@<Connector port=\"8009\" protocol=\"AJP/1.3\" redirectPort=\"8443\" />@<Connector port=\"8009\" protocol=\"AJP/1.3\" redirectPort=\"8443\" tomcatAuthentication=\"false\" packetSize=\"65536\" />@" /etc/tomcat7/server.xml


# Please also add the variable SOLR_BASE_URL to end of /etc/tomcat7/tomcat7.conf
# Example: SOLR_BASE_URL="http://52.24.49.48:8983/solr/"  where the IP is the SOLR server IP
# SOLR_BASE_URL="http://52.24.49.48:8983/solr/"

sudo chown tomcat /etc/tomcat7/tomcat7.conf

sudo cp rest.war /var/lib/tomcat7/webapps
sudo service tomcat7 restart


