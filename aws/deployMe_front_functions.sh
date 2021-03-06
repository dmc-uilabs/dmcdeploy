#!/bin/bash -v

function configureShibolethApache {
  # edit /etc/sysconfig/httpd
  sudo su -c "echo \"export LD_LIBRARY_PATH=/opt/shibboleth-sp/lib\" >>  /etc/sysconfig/httpd"
  # copy shibboleth SP Apache configuration to apache conf.d directory
  apacheConfigDir=configurationFiles/apache/version2.2
  sudo -u root -E cp $apacheConfigDir/apache22.conf /etc/httpd/conf.d/apache22.conf
}


function configureShibbolethServiceProvider {
    # configure SP:
    shibSPConfigDir=configurationFiles/shibbolethSP/version2.5.5
    # ensure any recent changes to the shib configuration are available to the deployment
    cd /tmp/dmcfrontend
    git pull
    mv -f $shibSPConfigDir/*.xml ../$shibSPConfigDir
    cd -
    # copy shibboleth SP configuration files to shibboleth SP configuration directory
    sudo -u root -E cp $shibSPConfigDir/attribute-map.xml /opt/shibboleth-sp/etc/shibboleth/attribute-map.xml
    sudo -u root -E cp $shibSPConfigDir/shibboleth2.xml /opt/shibboleth-sp/etc/shibboleth/shibboleth2.xml
    sudo -u root -E cp $shibSPConfigDir/CirrusIdentitySocialProviders-metadata.xml /opt/shibboleth-sp/etc/shibboleth/CirrusIdentitySocialProviders-metadata.xml
    sudo -u root -E cp $shibSPConfigDir/azure.xml /opt/shibboleth-sp/etc/shibboleth/azure.xml
    sudo -u root -E cp $shibSPConfigDir/FederationMetadataCirrus.xml /opt/shibboleth-sp/etc/shibboleth/FederationMetadataCirrus.xml
    ## update shibboleth SP entityID
    sudo -u root -E sed -i "s@test.projectdmc.org@$serverURL@" /opt/shibboleth-sp/etc/shibboleth/shibboleth2.xml
}

function moveShibbolethServiceProviderKeys {
    # need to copy sp-cert.pem to /opt/shibboleth-sp/etc/shibboleth/
    sudo -u root -E mv /tmp/sp-cert.pem /opt/shibboleth-sp/etc/shibboleth/sp-cert.pem
    sudo -u root -E chown root:root /opt/shibboleth-sp/etc/shibboleth/sp-cert.pem
    sudo -u root -E chmod 400 /opt/shibboleth-sp/etc/shibboleth/sp-cert.pem
    # need to copy sp-key.pem to /opt/shibboleth-sp/etc/shibboleth/
    sudo -u root -E mv /tmp/sp-key.pem /opt/shibboleth-sp/etc/shibboleth/sp-key.pem
    sudo -u root -E chown root:root /opt/shibboleth-sp/etc/shibboleth/sp-key.pem
    sudo -u root -E chmod 400 /opt/shibboleth-sp/etc/shibboleth/sp-key.pem

    sudo -u root -E mv /tmp/inc-md-cert.pem /opt/shibboleth-sp/etc/shibboleth/inc-md-cert.pem
    sudo -u root -E chown root:root /opt/shibboleth-sp/etc/shibboleth/inc-md-cert.pem
    sudo -u root -E chmod 400 /opt/shibboleth-sp/etc/shibboleth/inc-md-cert.pem
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
  echo "setting the login url -- serverURL is =$serverURL"
  if [ $serverURL == "beta.opendmc.org" ]
  then
    sed -i.bak "s|loginURL|https://apps.cirrusidentity.com/console/ds/index?entityID=https://$serverURL/shibboleth\&return=https://$serverURL/Shibboleth.sso/Login%3Ftarget%3Dhttps%3A%2F%2F$serverURL|" header-tpl.html
  else
    if [[ $serverURL == "dev-web.opendmc.org" ]]
      then
        sed -i.bak "s|loginURL|https://apps.cirrusidentity.com/console/ds/index?entityID=https://dev-web.opendmc.org/shibboleth\&return=https://$serverURL/Shibboleth.sso/Login%3Ftarget%3Dhttps%3A%2F%2F$serverURL|" header-tpl.html

      else
        sed -i.bak "s|loginURL|https://apps.cirrusidentity.com/console/ds/index?entityID=https://dev-web1.opendmc.org/shibboleth\&return=https://$serverURL/Shibboleth.sso/Login%3Ftarget%3Dhttps%3A%2F%2F$serverURL|" header-tpl.html
    fi
  fi
}

function frontendUpload {
  sed -i.bak "s|  var creds = {bucket: '', access_key: '',secret_key: ''}|  var creds = {bucket: '$AWS_UPLOAD_BUCKET', access_key: '$AWS_UPLOAD_KEY',secret_key: '$AWS_UPLOAD_SEC'}|" file-upload.js
  sed -i.bak "s|    AWS.config.region = '';|    AWS.config.region = '$AWS_UPLOAD_REGION';|" file-upload.js
}

function setWindowApiUrl {
  
  sed -i.bak "s|window.apiUrl = '';|window.apiUrl='https://$serverURL/rest'|" *.php

}
function commonInstallWebsiteConfig {
  setWindowApiUrl
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
