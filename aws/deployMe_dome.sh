#!/bin/bash
#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1


sudo service tomcat7 start
cd /tmp
rm -rf *
wget https://s3-us-west-2.amazonaws.com/dmc-dev-deploy/DOME_WAR/DOMEApiServicesV7.war

sudo cp DOMEApiServicesV7.war /var/lib/tomcat7/webapps



while [ ! -f /var/lib/tomcat7/webapps/DOMEApiServicesV7/WEB-INF/classes/config/config.properties ]
do
    echo "waiting"
    sleep 1
done
sudo cp /var/lib/tomcat7/webapps/DOMEApiServicesV7/WEB-INF/classes/config/config.properties .
echo "queue=tcp://$ActiveMQdns:61616" >> config.properties
echo "dome.server.user=$dome_server_user" >> config.properties
echo "dome.server.pw=$dome_server_pw" >> config.properties
sudo mv config.properties /var/lib/tomcat7/webapps/DOMEApiServicesV7/WEB-INF/classes/config/config.properties


sudo service tomcat7 restart


function sanityTest {
  cd ~
  response=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "localhost:8080/DOMEApiServicesV7/")
  echo "Attemting to see if server can be reached " >> domeSanityTest.log
  echo "server response -- $response" >> domeSanityTest.log

  echo "The commit we are pulling from >> $commit_dome" >> domeSanityTest.log
}

# sanityTest
