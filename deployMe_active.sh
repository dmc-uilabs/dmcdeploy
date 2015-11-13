#!/bin/bash -v
#!/bin/bash -v
# yum update -y
# yum install -y java-1.8.0-openjdk.x86_64
# yum erase -y java-1.7.0-openjdk
# yum install -y git
# yum install -y tomcat7
# yum install git -y


cd /tmp
git clone https://bitbucket.org/DigitalMfgCommons/dmcactivemq.git
cd dmcactivemq
mv * ..

/etc/init.d/sendmail stop 

mkdir /opt/activemq 
#!/bin/bash -v
cd /opt/activemq/ 

wget http://archive.apache.org/dist/activemq/apache-activemq/5.9.0/apache-activemq-5.9.0-bin.tar.gz 
tar -zxvf apache-activemq-5.9.0-bin.tar.gz 
/usr/sbin/useradd activemq 
touch /etc/default/activemq 
chown activemq /etc/default/activemq 
chmod 600 /etc/default/activemq 
sudo su activemq 

cd /tmp
echo "admin : $activeMqRoot, $activeMqRootPass" >> jetty-realm.properties 
echo "user : $activeUser, $activeMqUserPass" >> jetty-realm.properties 

cp -v  /tmp/jetty-realm.properties /opt/activemq/apache-activemq-5.9.0/conf/jetty-realm.properties


chmod 644 /opt/activemq/apache-activemq-5.9.0/conf/jetty-realm.properties
/opt/activemq/apache-activemq-5.9.0/bin/activemq start 
