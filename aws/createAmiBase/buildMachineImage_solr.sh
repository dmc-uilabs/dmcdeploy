#!/bin/bash -v

#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1

     sudo yum update -y
function buildAMIBase {
    #install needed packages
        sudo yum remove sendmail -y
        sudo yum install git -y

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

        # Install cron and scripts
        sudo yum install cronie -y
 
}



##command to create the AMI base
buildAMIBase

# remove unneeded software

