#!/bin/bash
#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1

mkdir ~/DMC
cd ~/DMC
rm -rf *
sudo chown ec2-user /etc/tomcat7/tomcat7.conf

echo "DBip=$DBip" >> /etc/tomcat7/tomcat7.conf
echo "DBport=$DBport" >> /etc/tomcat7/tomcat7.conf
echo "DBpass=$DBpass" >> /etc/tomcat7/tomcat7.conf
echo "DBuser=$DBuser" >> /etc/tomcat7/tomcat7.conf
echo "SOLR_BASE_URL=$solrDbDns" >> /etc/tomcat7/tomcat7.conf
sudo -u root -E sed -i "s@<Connector port=\"8009\" protocol=\"AJP/1.3\" redirectPort=\"8443\" />@<Connector port=\"8009\" protocol=\"AJP/1.3\" redirectPort=\"8443\" tomcatAuthentication=\"false\" packetSize=\"65536\" />@" /etc/tomcat7/server.xml
sudo chown tomcat /etc/tomcat7/tomcat7.conf


    if [[ $commit_rest == 'hot' ]]
    	then
    		echo "pull from S3 build from latest available build"
    		 wget https://s3-us-west-2.amazonaws.com/dmc-dev-deploy/DMC_SITE_SERVICES_WAR/dmc-site-services-0.1.0.war
    	else
  			echo "pull from S3 build from commit -- $commit_rest "
  			if [[ $use_swagger == '0' ]]
					then
					    wget https://s3-us-west-2.amazonaws.com/dmc-dev-deploy/DMC_SITE_SERVICES_WAR/$commit_rest-dmc-site-services-0.1.0.war
					else
						wget https://s3-us-west-2.amazonaws.com/dmc-dev-deploy/DMC_SITE_SERVICES_WAR/$commit_rest-dmc-site-services-0.1.0-swagger.war
			  fi
		fi
cp *.war rest.war

sudo cp rest.war /var/lib/tomcat7/webapps
sudo service tomcat7 start

function sanityTest {
    cd ~
    response=$(curl localhost:8080/rest/services/2)
    echo "Attemting to see if server can be reached " >> restSanityTest.log
    echo "server response from http://localhost:8080/rest/services/2 -- $response" >> restSanityTest.log
}

# sanityTest
