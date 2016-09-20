#!/bin/bash -v
#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1


# yum update -y
# yum install -y java-1.8.0-openjdk.x86_64
# yum erase -y java-1.7.0-openjdk
# yum install -y git
# yum install -y tomcat7
sudo yum install git -y


cd /tmp

if [[ $release == 'hot' ]]
	then
    			echo "pull from master"
    			git clone https://bitbucket.org/DigitalMfgCommons/dmcactivemq.git
	else
    			echo "pull from >> $release << release"
    			git clone https://bitbucket.org/DigitalMfgCommons/dmcactivemq.git
    			cd dmcactivemq
				echo "git checkout tags/$release"  | bash -

fi

cd /tmp/dmcactivemq
mv * ..

# Copy our custom startup script to /etc/init.d and set appropriate permissions
# this makes the command "service activemq start|stop|restart" possible
sudo cp /tmp/activemq /etc/init.d/.
sudo chmod 755 /etc/init.d/activemq
# Configure system to start the activemq service automatically
sudo chkconfig activemq on


sudo cp -v  /tmp/jetty-realm.properties /opt/activemq/conf/jetty-realm.properties
sudo echo "admin: $activeMqRootPass, admin" >> /opt/activemq/conf/jetty-realm.properties
sudo echo "user: $activeMqUserPass, user" >> /opt/activemq/conf/jetty-realm.properties
#start ActiveMQ
sudo service activemq start
