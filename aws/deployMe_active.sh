#!/bin/bash -v
#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1


# yum update -y
# yum install -y java-1.8.0-openjdk.x86_64
# yum erase -y java-1.7.0-openjdk
# yum install -y git
# yum install -y tomcat7
# yum install git -y


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
# /etc/init.d/sendmail stop


sudo echo "admin: $activeMqRootPass, admin" >> /tmp/jetty-realm.properties
sudo echo "user: $activeMqUserPass, user" >> /tmp/jetty-realm.properties

wget http://mirror.cc.columbia.edu/pub/software/apache/activemq/5.13.2/apache-activemq-5.13.2-bin.tar.gz
tar zxvf apache-activemq-5.13.2-bin.tar.gz

sudo mv apache-activemq-5.13.2 /opt
sudo ln -sf /opt/apache-activemq-5.13.2/ /opt/activemq


# Copy our custom startup script to /etc/init.d and set appropriate permissions
# this makes the command "service activemq start|stop|restart" possible
sudo cp /tmp/activemq /etc/init.d/.
sudo chmod 755 /etc/init.d/activemq
# Configure system to start the activemq service automatically
sudo chkconfig activemq on


sudo cp -v  /tmp/jetty-realm.properties /opt/activemq/conf/jetty-realm.properties

#start ActiveMQ
cd /opt/activemq/bin
./activemq start

function sanityTest {


cd ~



response=$(netstat -an|grep 61616)
echo "Attemting to see if server is bound to port 61616 " >> activeMqSanityTest.log
echo "server response -- $response" >> activeMqSanityTest.log

echo "Attemting to see if admin console can be reached for ActiveMQ" >> activeMqSanityTest.log
res=$(curl --user admin:$activeMqRootPass -o /dev/null --silent --head --write-out '%{http_code}' localhost:8161/admin/index.jsp)
echo "Server response $res" >> activeMqSanityTest.log


echo "The commit we are pulling from >> $commit_activeMq" >> activeMqSanityTest.log




}

sanityTest
