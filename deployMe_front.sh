#!/bin/bash -v

### NEEDED Variables
# $createNewAMI
# $serverURL
##########

#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1

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
    sudo -u root -E cp $shibSPConfigDir/azure.xml /opt/shibboleth-sp/etc/shibboleth/azure.xml
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

function ajpProxy {

    sudo su -c "echo \"ProxyIOBufferSize 65536\" >>  /etc/httpd/conf/httpd.conf"

    sudo su -c "echo \"ProxyPass /rest ajp://$restIP:8009/rest\" >>  /etc/httpd/conf/httpd.conf"

}


function setLoginUrl {

  sed -i.bak "s|loginURL|https://apps.cirrusidentity.com/console/ds/index?entityID=https://$serverURL/shibboleth\&return=https://$serverURL/Shibboleth.sso/Login%3Ftarget%3Dhttps%3A%2F%2F$serverURL|" header-tpl.html

}



function commonInstallWebsiteConfig {

   cd /tmp/dist/
   echo ">>>>$Restip<<<<"
   sed -i.bak "s|window.apiUrl = '';|window.apiUrl='https://$serverURL/rest'|" *.php
   sudo mkdir -p /var/www/
   sudo mkdir -p /var/www/html
   sudo mv /tmp/dist/* /var/www/html/.
   cd /var/www/html
   sudo chown -R apache:apache *
}


function installWebsite {
    # download newest build to tmp
    cd /tmp
    echo "value of commit_front is $commit_front"
    if [[ $commit_front == 'hot' ]]

      then
          echo "pull from latest build"
          wget https://s3.amazonaws.com/dmc-frontend-distribution/DMCFrontendDist.zip
      else
          echo "pull from >> $commit_front << commit"
          wget https://s3.amazonaws.com/dmc-frontend-distribution/$commit_front-DMCFrontendDist.zip

    fi


    rm -fr /tmp/dist
    unzip *.zip  #code is now in /tmp/dist

    # move code to clean webroot and change owner to apache
    sudo rm -rf /var/www/html/*
    cd /tmp/dist/templates/common/header

    echo "set loginURL to $loginURL "
    setLoginUrl


   cd /tmp/dist/

   commonInstallWebsiteConfig

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



    cd /tmp/dmcfrontend/dist/templates/common/header

    echo "set loginURL to $loginURL "
    setLoginUrl



    cd /tmp/dmcfrontend/dist


    commonInstallWebsiteConfig



}


function httpToHttpsRewrite {
    sudo su -c "echo \"RewriteEngine on\" >>  /etc/httpd/conf/httpd.conf"
    sudo su -c "echo \"RewriteCond %{HTTP:X-Forwarded-Proto} ^http$\" >>  /etc/httpd/conf/httpd.conf"
    sudo su -c "echo \"RewriteRule .* https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]\" >>  /etc/httpd/conf/httpd.conf"
}




function setLogLevel {
###########################################################
#
# tests for appropriate log level settings in php.ini
#
# author: james.barkley@uilabs.org
#
# last update: Jan 2016
#
###########################################################

#uncomment to test pre-set variable $loglevel
#export loglevel='development'
#export loglevel='nonsense'

# first, test to make sure variable exists
if [ -z "$loglevel" ]; then
  export loglevel='production'
fi


# next, make sure variable is in the valid range (production, development)
if [ "$loglevel" == "production" ]; then
  echo "loglevel is $loglevel"
elif [ "$loglevel" == "development" ]; then
  echo "loglevel is $loglevel"
else
  export loglevel='production'
  echpo "loglevel is $loglevel"
fi

sudo cp /etc/php.ini php.ini.orig

# finally, depending on loglevel, update php.ini file
if [ "$loglevel" == "production" ]; then
  echo "setting loglevel to prod environment"
  sudo sed -i "s/^error_reporting\s*=.*/error_reporting= E_STRICT/" /etc/php.ini
  sudo sed -i "s/^display_errors\s*=.*/display_errors = Off/" /etc/php.ini
  sudo sed -i "s/^display_startup_errors\s*=.*/display_startup_errors = Off/" /etc/php.ini
  sudo sed -i "s/^html_errors\s*=.*/display_html_errors = Off/" /etc/php.ini
  sudo sed -i "s/^log_errors\s*=.*/log_errors = On/" /etc/php.ini
else
  echo "setting loglevel to dev environment"
  sudo sed -i "s/^error_reporting\s*=.*/error_reporting= E_ALL/" /etc/php.ini
  sudo sed -i "s/^display_errors\s*=.*/display_errors = On/" /etc/php.ini
  sudo sed -i "s/^display_startup_errors\s*=.*/display_startup_errors = On/" /etc/php.ini
  sudo sed -i "s/^html_errors\s*=.*/display_html_errors = On/" /etc/php.ini
  sudo sed -i "s/^log_errors\s*=.*/log_errors = On/" /etc/php.ini
fi

}


function sanityTest {


cd ~



response=$(curl -o /dev/null --silent --head --write-out '%{http_code}' "localhost")
echo "Attemting to see if server can be reached " >> frontSanityTest.log
echo "server response -- $response" >> frontSanityTest.log

echo "Showing that certs made it to right place -- " >> frontSanityTest.log
find /opt/shibboleth-sp/etc/shibboleth -name "sp*" >> frontSanityTest.log

echo "The commit we are pulling from >> $commit_front" >> frontSanityTest.log




}



##set the appropriate level of logging
setLogLevel

configureShibbolethServiceProvider


##command to install from latest auto build from bamboo -- cannot be used to install particular release
configureApache

## used to redirect traffic from HTTP to HTTPS
httpToHttpsRewrite


## add rest services proxy configuration

ajpProxy



moveShibbolethServiceProviderKeys

## update shibboleth SP entityID
sudo -u root -E sed -i "s@test.projectdmc.org@$serverURL@" /opt/shibboleth-sp/etc/shibboleth/shibboleth2.xml

sudo -u root -E sed -i "s@REMOTE_USER=\"eppn persistent-id targeted-id\"@REMOTE_USER=\"eppn persistent-id targeted-id\" attributePrefix=\"AJP_\"@" /opt/shibboleth-sp/etc/shibboleth/shibboleth2.xml



installWebsite

##command to install from official DMC build repos -- used to install a particular release
#installWebsiteDMCrepos

# start apache then shibboleth
sudo /etc/init.d/httpd start
sudo /opt/shibboleth-sp/sbin/shibd


sanityTest
