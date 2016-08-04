#!/bin/bash -v
#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1




 sudo yum remove sendmail -y
 sudo yum install git -y

#elasticsearch
sudo rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch

echo '[elasticsearch-2.x]
name=Elasticsearch repository for 2.x packages
baseurl=http://packages.elastic.co/elasticsearch/2.x/centos
gpgcheck=1
gpgkey=http://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1
' | sudo tee /etc/yum.repos.d/elasticsearch.repo

# Install Elasticsearch with this command:

sudo yum -y install elasticsearch

# Edit the configuration:
sudo sed -i.bak "s|# network.host: 192.168.0.1|network.host: localhost|" /etc/elasticsearch/elasticsearch.yml

sudo service elasticsearch start

sudo chkconfig elasticsearch on


###kibana
echo '[kibana-4.4]
name=Kibana repository for 4.4.x packages
baseurl=http://packages.elastic.co/kibana/4.4/centos
gpgcheck=1
gpgkey=http://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1
' | sudo tee /etc/yum.repos.d/kibana.repo

sudo yum -y install kibana


sudo sed -i.bak 's|# server.host: "0.0.0.0"|server.host: "localhost"|' /opt/kibana/config/kibana.yml

# Now start the Kibana service, and enable it:

sudo service kibana start
sudo chkconfig kibana on


# Install Nginx
# Add the EPEL repository to yum:

sudo yum -y install epel-release

sudo yum -y install nginx httpd-tools
