#!/bin/bash
#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1
# yum update -y
# yum install -y java-1.8.0-openjdk.x86_64
# yum erase -y java-1.7.0-openjdk
# yum install -y git
# yum install -y tomcat7
sudo /etc/init.d/tomcat7 start
cd /tmp

rm -rf *

if [[ $release == 'hot' ]]
	then
    			echo "pull from master"
    			git clone https://bitbucket.org/DigitalMfgCommons/dmcdomeserver.git
	else
    			echo "pull from >> $release << release"
    			git clone https://bitbucket.org/DigitalMfgCommons/dmcdomeserver.git
                cd dmcdomeserver
				echo "git checkout tags/$release"  | bash -

fi


cd /tmp/dmcdomeserver

#mvn package

sudo cp DOMEApiServicesV7.war /var/lib/tomcat7/webapps
echo "queue=tcp://$ActiveMQdns:61616" >> config.properties
echo "dome.server.user=$dome_server_user" >> config.properties
echo "dome.server.pw=$dome_server_pw" >> config.properties

while [ ! -f /var/lib/tomcat7/webapps/DOMEApiServicesV7/WEB-INF/classes/config/config.properties ]
do
    echo "waiting"
    sleep 1
done

sudo cp config.properties /var/lib/tomcat7/webapps/DOMEApiServicesV7/WEB-INF/classes/config/config.properties
sudo /etc/init.d/tomcat7 restart


function sanityTest {


cd ~



response=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "localhost:8080/DOMEApiServicesV7/")
echo "Attemting to see if server can be reached " >> domeSanityTest.log
echo "server response -- $response" >> domeSanityTest.log



echo "The commit we are pulling from >> $commit_dome" >> domeSanityTest.log




}

sanityTest
