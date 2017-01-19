#!/bin/bash -v

source /etc/profile.d/dmc.sh
sudo yum -y install wget openjdk-8-jdk httpd php
cd /tmp
sudo rm *.rpm
sudo yum -y install https://s3.amazonaws.com/dmc-build-aritifacts/$release/front/rh_httpd24_shibsp-1.0.0-1.x86_64.rpm
echo export LD_LIBRARY_PATH=/opt/shibboleth-sp/lib | sudo tee -a /etc/sysconfig/httpd
# sudo cp /opt/shibboleth-sp/etc/shibboleth/apache22.conf /etc/httpd/conf.d
sudo cp /tmp/apache24.conf /etc/httpd/conf.d/apache24.conf
# sudo sed -e -i 's/mod_shib_22.so/mod_shib_24.so' /etc/httpd/conf.d/apache22.conf
# sudo sed -e -i 's/  ShibCompatWith24 On/' /etc/httpd/conf.d/apache22.conf
# sudo sed -e -i 's/  ShibRequestSetting requireSession 1/' /etc/httpd/conf.d/apache22.conf
sudo su -c "echo \"RewriteEngine on\" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"RewriteCond %{HTTP:X-Forwarded-Proto} ^http$\" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"RewriteRule .* https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]\" >>  /etc/httpd/conf/httpd.conf"
sudo -u root -E sed -i "s@#ServerName www.example.com:80@ServerName https://$serverURL@" /etc/httpd/conf/httpd.conf
sudo -u root -E sed -i "s/UseCanonicalName Off/UseCanonicalName On/" /etc/httpd/conf/httpd.conf
sudo su -c "echo \"ProxyIOBufferSize 65536\" >>  /etc/httpd/conf/httpd.conf"
#ensure it outputs corectly
sudo su -c "echo \"ProxyPass /rest ajp://$restIp:8009/rest\" >>  /etc/httpd/conf/httpd.conf"


sudo sed -i "s/^error_reporting\s*=.*/error_reporting= E_ALL/" /etc/php.ini
sudo sed -i "s/^display_errors\s*=.*/display_errors = On/" /etc/php.ini
sudo sed -i "s/^display_startup_errors\s*=.*/display_startup_errors = On/" /etc/php.ini
sudo sed -i "s/^html_errors\s*=.*/display_html_errors = On/" /etc/php.ini
sudo sed -i "s/^log_errors\s*=.*/log_errors = On/" /etc/php.ini


sudo mkdir -p /var/www/html
cd /tmp


wget https://s3.amazonaws.com/dmc-build-aritifacts/$release/front/dist0117.tar.gz
rm -fr dist
mkdir dist
tar -xvzf dist0117.tar.gz -C dist

sudo cp -r /tmp/dist/dist/* /var/www/html
cd /var/www/html/templates/common/header
if [ $mode == development ] ; then
  echo "System is set up for Develpment Mode."
  sudo sed -i.bak "s|loginURL|https://apps.cirrusidentity.com/console/ds/index?entityID=https://dev-web1.opendmc.org/shibboleth\&return=https://$serverURL/Shibboleth.sso/Login%3Ftarget%3Dhttps%3A%2F%2F$serverURL|" header-tpl.html
else
  sudo sed -i.bak "s|loginURL|https://apps.cirrusidentity.com/console/ds/index?entityID=https://beta.opendmc.org/shibboleth\&return=https://$serverURL/Shibboleth.sso/Login%3Ftarget%3Dhttps%3A%2F%2F$serverURL|" header-tpl.html
  sudo sed -i.bak "s|dev-web1|beta|" /opt/shibboleth-sp/etc/shibboleth/shibboleth2.xml

fi


cd /var/www/html/scripts/common/models/
sudo sed -i.bak "s|  var creds = {bucket: '', access_key: '',secret_key: ''}|  var creds = {bucket: '$AWS_UPLOAD_BUCKET', access_key: '$AWS_UPLOAD_KEY',secret_key: '$AWS_UPLOAD_SEC'}|" file-upload.js
sudo sed -i.bak "s|    AWS.config.region = '';|    AWS.config.region = '$AWS_UPLOAD_REGION';|" file-upload.js
cd /var/www/html
sudo sed -i.bak "s|window.apiUrl = '';|window.apiUrl='https://$serverURL/rest'|" *.php
sudo chown -R apache:apache /var/www/html
 # sudo bash /opt/shibboleth-sp/etc/shibboleth/shibd-redhat start
 # sudo systemctl start httpd
sudo systemctl stop firewalld
sudo systemctl disable firewalld
