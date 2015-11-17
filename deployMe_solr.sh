#!/bin/bash -v
# yum update -y
# yum install -y java-1.8.0-openjdk.x86_64
# yum erase -y java-1.7.0-openjdk
# yum install -y git
# yum install -y tomcat7
# yum install git -y


# Download DMC Solr files
cd /tmp
rm -fr /tmp/dmcsolr
git clone https://bitbucket.org/DigitalMfgCommons/dmcsolr.git
cd dmcsolr

# Unpacking solr configuration
rm -fr /tmp/solr
mkdir /tmp/solr
cd /tmp/solr
tar xvfz /tmp/dmcsolr/files/solr5.tar.gz

# download solr 
echo Downloading and installing solr
sudo rm -fr /opt/solr
sudo mkdir /opt/solr
cd /opt/solr
sudo wget http://archive.apache.org/dist/lucene/solr/5.3.1/solr-5.3.1.tgz 
sudo tar xvzf solr-5.3.1.tgz 

# Note home directory for Solr is
# /opt/solr/solr-5.3.1/server/solr

# Moving configuration directories to solr home
echo moving DMC solr configuration files to solr home /opt/solr/solr-5.3.1/server/solr
sudo mv -f /tmp/solr/LuceneSolrConfig/* /opt/solr/solr-5.3.1/server/solr

# Edit components.data-config.xml
cd /tmp/dmcsolr
sudo sed "s/SOLR_DB_DNS/$solrDbDns/" files/components.data-config.xml > /opt/solr/apache-solr-3.6.0/home/solr/components/conf/data-config.xml

# Edit projects.data-config.xml
sudo sed "s/SOLR_DB_DNS/$solrDbDns/" files/projects.data-config.xml > /opt/solr/apache-solr-3.6.0/home/solr/projects/conf/data-config.xml

# Edit services.data-config.xml
sudo sed "s/SOLR_DB_DNS/$solrDbDns/" files/services.data-config.xml > /opt/solr/apache-solr-3.6.0/home/solr/services/conf/data-config.xml

# Edit users.data-config.xml
sudo sed "s/SOLR_DB_DNS/$solrDbDns/" files/users.data-config.xml > /opt/solr/apache-solr-3.6.0/home/solr/users/conf/data-config.xml

# Edit wiki.data-config.xml
sudo sed "s/SOLR_DB_DNS/$solrDbDns/" files/wiki.data-config.xml > /opt/solr/apache-solr-3.6.0/home/solr/wiki/conf/data-config.xml

#
echo starting solr
sudo /opt/solr/solr-5.3.1/bin/solr start
