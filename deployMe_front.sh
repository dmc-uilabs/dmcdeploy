#!/bin/bash -v

### NEEDED Variables
# $createNewAMI
# $serverURL
##########

#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1

   

function buildAMIBase {
    #install needed packages
    sudo yum remove sendmail -y
    sudo yum install httpd -y
    sudo yum install php php-pgsql -y
    sudo yum install wget -y
    sudo yum install git -y

    # get Shibbolth service provider install script
    git clone https://bitbucket.org/DigitalMfgCommons/dmcfrontend.git
    # move Shibbolth service provider install script
    mv dmcfrontend/install_ShibbolthSpDependencies.sh .
    # move Shibbolth configuration files
    mv dmcfrontend/configurationFiles .

    # install Shibbolth service provider and dependencies
    ./install_ShibbolthSpDependencies.sh
    configureShibbolethServiceProvider
}

function configureShibbolethServiceProvider {
    # configure SP:

    # edit /etc/sysconfig/httpd
    sudo su -c "echo \"export LD_LIBRARY_PATH=/opt/shibboleth-sp/lib\" >>  /etc/sysconfig/httpd"
    
    # copy shibboleth SP Apache configuration to apache conf.d directory
    apacheConfigDir=configurationFiles/apache/version2.2
    sudo -u root -E cp $apacheConfigDir/apache22.conf /etc/httpd/conf.d/apache22.conf

    # copy shibboleth SP configuration files to shibboleth SP configuration directory
    shibSPConfigDir=configurationFiles/shibbolethSP/version2.5.5
    sudo -u root -E cp $shibSPConfigDir/attribute-map.xml /opt/shibboleth-sp/etc/shibboleth/attribute-map.xml
    sudo -u root -E cp $shibSPConfigDir/shibboleth2.xml /opt/shibboleth-sp/etc/shibboleth/shibboleth2.xml
    sudo -u root -E cp $shibSPConfigDir/CirrusIdentitySocialProviders-metadata.xml /opt/shibboleth-sp/etc/shibboleth/CirrusIdentitySocialProviders-metadata.xml
}

function moveShibbolethServiceProviderKeys {
    # need to copy sp-cert.pem to /opt/shibboleth-sp/etc/shibboleth/
    sudo -u root -E mv /tmp/sp-cert.pem /opt/shibboleth-sp/etc/shibboleth/sp-cert.pem
    sudo -u root -E chown root:root /opt/shibboleth-sp/etc/shibboleth/sp-cert.pem
    # need to copy sp-key.pem to /opt/shibboleth-sp/etc/shibboleth/
    sudo -u root -E mv /tmp/sp-key.pem /opt/shibboleth-sp/etc/shibboleth/sp-key.pem
    sudo -u root -E chown root:root /opt/shibboleth-sp/etc/shibboleth/sp-key.pem
    sudo -u root -E chmod 600 /opt/shibboleth-sp/etc/shibboleth/sp-key.pem
}

function configureApache {
    # edit /etc/sysconfig/httpd
    sudo -u root -E sed -i "s@#HTTPD=/usr/sbin/httpd.worker@HTTPD=/usr/sbin/httpd.worker@" /etc/sysconfig/httpd

    # edit /etc/httpd/conf/httpd.conf

    # serverURL is needed in httpd.conf and is already set by terraform
    sudo -u root -E sed -i "s@#ServerName www.example.com:80@ServerName https://$serverURL@" /etc/httpd/conf/httpd.conf
    sudo -u root -E sed -i "s/UseCanonicalName Off/UseCanonicalName On/" /etc/httpd/conf/httpd.conf
}

function installWebsite {
    # download newest build to tmp
    cd /tmp

    wget https://s3.amazonaws.com/dmc-frontend-distribution/DMCFrontendDist.zip 
    unzip DMCFrontendDist.zip  #code is now in /tmp/dist

    # move code to clean webroot and change owner to apache
   sudo rm -rf /var/www/html/*
   cd /tmp/dist/
   echo ">>>>$Restip<<<<"
   sed -i.bak "s|window.apiUrl = '';|window.apiUrl='https://$Restip/rest'|" *.php
   sudo mkdir -p /var/www/
   sudo mkdir -p /var/www/html
   sudo mv /tmp/dist/* /var/www/html/.
   cd /var/www/html
   sudo chown -R apache:apache *
}


function installWebsiteDMCrepos {
    # download newest build to tmp
    cd /tmp

   
    if [[ $release == 'hot' ]]

    then
        echo "pull from master"
        git clone https://bitbucket.org/DigitalMfgCommons/dmcfrontend.git
    else
        echo "pull from >> $release << release"
        git clone https://bitbucket.org/DigitalMfgCommons/dmcfrontend.git
        cd dmcfrontend          
    echo "git checkout tags/$release"  | bash -
    fi

  
    # move code to clean webroot and change owner to apache
    sudo rm -rf /var/www/html/*
    cd /tmp/dmcfrontend/dist
    
    echo ">>>>$Restip<<<<"
    sed -i.bak "s|window.apiUrl = '';|window.apiUrl='http://$Restip:8080/rest'|" *.php
    sudo mkdir -p /var/www/
    sudo mkdir -p /var/www/html
    sudo mv /tmp/dmcfrontend/dist/* /var/www/html/
    cd /var/www/html
    sudo chown -R apache:apache *
}


function httpToHttpsRewrite {
    sudo su -c "echo \"RewriteEngine on\" >>  /etc/httpd/conf/httpd.conf"
    sudo su -c "echo \"RewriteCond %{HTTP:X-Forwarded-Proto} ^http$\" >>  /etc/httpd/conf/httpd.conf"
    sudo su -c "echo \"RewriteRule .* https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]\" >>  /etc/httpd/conf/httpd.conf"
}

##command to create the AMI base
#buildAMIBase



##command to install from latest auto build from bamboo -- cannot be used to install particular release
configureApache

## used to redirect traffic from HTTP to HTTPS
httpToHttpsRewrite

moveShibbolethServiceProviderKeys

## update shibboleth SP entityID
sudo -u root -E sed -i "s@test.projectdmc.org@$serverURL@" /opt/shibboleth-sp/etc/shibboleth/shibboleth2.xml

installWebsite
    
##command to install from official DMC build repos -- used to install a particular release
#installWebsiteDMCrepos

# start apache then shibboleth
sudo /etc/init.d/httpd start
sudo /opt/shibboleth-sp/sbin/shibd
