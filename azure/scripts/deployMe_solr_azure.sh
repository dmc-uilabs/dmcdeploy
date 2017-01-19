#!/bin/bash -v
#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1

sudo yum remove sendmail -y
sudo yum install git -y

function getRepo {

  echo "showing the var $solrDbDns"
  env | grep "$solrDbDns"
  echo " ---- "

  cd /tmp
  rm -fr /tmp/dmcsolr

  # if [[ $release == 'hot' ]]
  # then
  #   echo "pull from master"
  #   git clone https://bitbucket.org/DigitalMfgCommons/dmcsolr.git
  # else
  #   echo "pull from >> $release << release"
  #   git clone https://bitbucket.org/DigitalMfgCommons/dmcsolr.git
  #   cd dmcsolr
  #   echo "git checkout tags/$release"  | bash -
  #
  # fi
  git clone https://bitbucket.org/DigitalMfgCommons/dmcsolr.git

  cd /tmp/dmcsolr

  # re-create solr5.tar.gz
  echo "Creating solr5.tar.gz"
  pwd
  cd solr5
  rm -fr ../files/solr5.tar.gz
  tar acf ../files/solr5.tar.gz .
  cd ..
  ls -l files/solr5.tar.gz

}

function installSolr {

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

  # Install cron and scripts
  sudo yum install cronie -y
}

function configureSolr {

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
  sudo -u solr -E sed -e "s/SOLR_DB_DNS/$solrDbDns/" -e "s/SOLR_DB_PORT/$solrDbPort/" files/components.data-config.xml > /var/solr/data/gforge/components/conf/data-config.xml

  # Edit companies.data-config.xml
  sudo -u solr -E sed -e "s/SOLR_DB_DNS/$solrDbDns/" -e "s/SOLR_DB_PORT/$solrDbPort/" files/companies.data-config.xml > /var/solr/data/gforge/companies/conf/data-config.xml

  # Edit projects.data-config.xml
  sudo -u solr -E sed -e "s/SOLR_DB_DNS/$solrDbDns/" -e "s/SOLR_DB_PORT/$solrDbPort/" files/projects.data-config.xml > /var/solr/data/gforge/projects/conf/data-config.xml

  # Edit services.data-config.xml
  sudo -u solr -E sed -e "s/SOLR_DB_DNS/$solrDbDns/" -e "s/SOLR_DB_PORT/$solrDbPort/" files/services.data-config.xml > /var/solr/data/gforge/services/conf/data-config.xml

  # Edit users.data-config.xml
  sudo -u solr -E sed -e "s/SOLR_DB_DNS/$solrDbDns/" -e "s/SOLR_DB_PORT/$solrDbPort/" files/users.data-config.xml > /var/solr/data/gforge/users/conf/data-config.xml

  # Edit wiki.data-config.xml
  sudo -u solr -E sed -e "s/SOLR_DB_DNS/$solrDbDns/" -e "s/SOLR_DB_PORT/$solrDbPort/" files/wiki.data-config.xml > /var/solr/data/gforge/wiki/conf/data-config.xml

  sudo -u solr cp -r files/scripts  /var/solr
  sudo -u solr chmod +x /var/solr/scripts/*.sh
  sudo -u solr crontab files/scripts/cron_solr_index
  sudo -u solr crontab -l

  # Ensure cron is running
  sudo service crond start
  sudo service crond status

  # Restart solr
  echo restart solr
  sudo service solr restart

  # check solr status
  echo check solr status
  sudo service solr status

}

#get appropriate code
getRepo

#install solr
installSolr

# configure solr and the cron jobs
configureSolr

sudo systemctl stop firewalld
sudo systemctl disable firewalld
