#!/bin/bash -v
# yum update -y
# yum install -y java-1.8.0-openjdk.x86_64
# yum erase -y java-1.7.0-openjdk
# yum install -y git
# yum install -y tomcat7
# yum install git -y


cd /tmp
source ~/.bashrc 
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
# /etc/init.d/sendmail stop


sudo echo "admin: $activeMqRootPass, admin" >> /tmp/jetty-realm.properties
sudo echo "user: $activeMqUserPass, user" >> /tmp/jetty-realm.properties

wget http://mirror.cc.columbia.edu/pub/software/apache/activemq/5.12.1/apache-activemq-5.12.1-bin.tar.gz
tar zxvf apache-activemq-5.12.1-bin.tar.gz 

sudo mv apache-activemq-5.12.1 /opt
sudo ln -sf /opt/apache-activemq-5.12.1/ /opt/activemq


# Copy our custom startup script to /etc/init.d and set appropriate permissions
# this makes the command "service activemq start|stop|restart" possible
sudo cp /tmp/activemq /etc/init.d/.
sudo chmod 755 /etc/init.d/activemq
# Configure system to start the activemq service automatically
sudo chkconfig activemq on


cp -v  /tmp/jetty-realm.properties /opt/activemq/conf/jetty-realm.properties
