exec 1> >(logger -s -t $(basename $0)) 2>&1

source /etc/profile.d/dmc.sh

cd /tmp

git clone https://github.com/dmc-uilabs/dmcactive.git

cd /tmp/dmcactive
mv * ..

sudo useradd -m activemq -d /opt/activemq
sudo chown -R activemq:dmcAdmin /opt/apache-activemq-5.14.4/

sudo cp /opt/activemq/bin/env /etc/default/activemq
sudo sed -i '~s/^ACTIVEMQ_USER=""/ACTIVEMQ_USER="activemq"/' /etc/default/activemq
sudo chmod 644 /etc/default/activemq

sudo ln -snf  /opt/activemq/bin/activemq /etc/init.d/activemq
sudo chkconfig --add activemq

sudo chkconfig activemq on

sudo cp -v  /tmp/jetty-realm.properties /opt/activemq/conf/jetty-realm.properties
echo "admin: $activeMqRootPass, admin" | sudo tee -a /opt/activemq/conf/jetty-realm.properties
echo "user: $activeMqUserPass, user" | sudo tee -a /opt/activemq/conf/jetty-realm.properties
#start ActiveMQ
sudo service activemq start
