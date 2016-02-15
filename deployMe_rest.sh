#!/bin/bash
#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1

sudo service tomcat7 start

mkdir ~/DMC
cd ~/DMC
rm -rf *

env | grep "rel"

if [[ $release == 'hot' ]]
	then

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

	else
    			echo "pull from >> $release << release"
    			git clone https://bitbucket.org/DigitalMfgCommons/dmcrestservices.git
    			cd dmcrestservices
				echo "git checkout tags/$release"  | bash -
				
				
				cd ~/DMC/dmcrestservices/target

				if [[ $use_swagger == '0' ]]
					then
						cp *.war rest.war
					else
						cp *-swagger.war rest.war

				fi

fi





sudo chown ec2-user /etc/tomcat7/tomcat7.conf 

echo "DBip=$DBip" >> /etc/tomcat7/tomcat7.conf
echo "DBport=$DBport" >> /etc/tomcat7/tomcat7.conf
echo "DBpass=$DBpass" >> /etc/tomcat7/tomcat7.conf
echo "DBuser=$DBuser" >> /etc/tomcat7/tomcat7.conf
echo "SOLR_BASE_URL=$solrDbDns" >> /etc/tomcat7/tomcat7.conf 
sudo -u root -E sed -i "s@<Connector port=\"8009\" protocol=\"AJP/1.3\" redirectPort=\"8443\" />@<Connector port=\"8009\" protocol=\"AJP/1.3\" redirectPort=\"8443\" tomcatAuthentication=\"false\" packetSize=\"65536\" />@" /etc/tomcat7/server.xml




sudo chown tomcat /etc/tomcat7/tomcat7.conf

sudo cp rest.war /var/lib/tomcat7/webapps
sudo service tomcat7 restart


