#!/bin/bash -v
#
# deployMe.sh for Apache Solr
#


# Download DMC Solr files
cd /tmp
rm -fr /tmp/dmcsolr
git clone https://bitbucket.org/DigitalMfgCommons/dmcsolr.git
cd dmcsolr


# download solr 
echo Downloading and installing solr
rm -fr /tmp/solr_install
mkdir /tmp/solr_install
cd /tmp/solr_install
wget http://archive.apache.org/dist/lucene/solr/5.3.1/solr-5.3.1.tgz 
tar xzf solr-5.3.1.tgz solr-5.3.1/bin/install_solr_service.sh --strip-components=2

# invoke solr install script
# Defaults
# Solr installed at /opt/solr
# Solr home dir  at /var/solr/data
# The script will add user: solr
echo Invoking solr install script
sudo bash ./install_solr_service.sh  solr-5.3.1.tgz

# check solr status
echo check solr service status
sudo service solr status

# Unpacking solr configuration
rm -fr /tmp/solr
mkdir /tmp/solr
cd /tmp/solr
tar xvfz /tmp/dmcsolr/files/solr5.tar.gz

# Log in as solr user
echo chown directories to solr
sudo chown -R solr /tmp/solr
sudo chown -R solr /tmp/dmcsolr

# Moving configuration directories to solr home
echo moving DMC solr configuration files to solr home /var/solr/data
sudo -u solr mv -f /tmp/solr/LuceneSolrConfig/* /var/solr/data/.

# Edit components.data-config.xml
echo "Editing SolR data configurations to use solrDbDns=$solrDbDns"
cd /tmp/dmcsolr
sudo -u solr -E sed "s/SOLR_DB_DNS/$solrDbDns/" files/components.data-config.xml > /var/solr/data/gforge/components/conf/data-config.xml

# Edit projects.data-config.xml
sudo -u solr -E sed "s/SOLR_DB_DNS/$solrDbDns/" files/projects.data-config.xml > /var/solr/data/gforge/projects/conf/data-config.xml

# Edit services.data-config.xml
sudo -u solr -E sed "s/SOLR_DB_DNS/$solrDbDns/" files/services.data-config.xml > /var/solr/data/gforge/services/conf/data-config.xml

# Edit users.data-config.xml
sudo -u solr -E sed "s/SOLR_DB_DNS/$solrDbDns/" files/users.data-config.xml > /var/solr/data/gforge/users/conf/data-config.xml

# Edit wiki.data-config.xml
sudo -u solr -E sed "s/SOLR_DB_DNS/$solrDbDns/" files/wiki.data-config.xml > /var/solr/data/gforge/wiki/conf/data-config.xml

# Restart solr
echo restart solr
sudo service solr restart

# check solr status
echo check solr status
sudo service solr status
