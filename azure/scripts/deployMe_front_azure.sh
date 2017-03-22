#!/bin/bash -v

source /etc/profile.d/dmc.sh
sudo yum -y install httpd php
cd /tmp
sudo rm *.rpm
echo export LD_LIBRARY_PATH=/opt/shibboleth-sp/lib | sudo tee -a /etc/sysconfig/httpd

#Build Proxy File
echo "ServerName https://$dmcURL" | sudo tee -a /etc/httpd/conf.d/proxy.conf
echo "UseCanonicalName On" | sudo tee -a /etc/httpd/conf.d/proxy.conf
echo "RewriteEngine on" | sudo tee -a /etc/httpd/conf.d/proxy.conf
echo "RewriteCond %{HTTP:X-Forwarded-Proto} ^http$" | sudo tee -a /etc/httpd/conf.d/proxy.conf
echo "RewriteRule .* https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]" | sudo tee -a /etc/httpd/conf.d/proxy.conf
echo "ProxyIOBufferSize 65536" | sudo tee -a /etc/httpd/conf.d/proxy.conf
echo "ProxyPass /rest/verify !" | sudo tee -a /etc/httpd/conf.d/proxy.conf
echo "ProxyPass /rest/companies ajp://$restIp:8009/rest/companies" | sudo tee -a /etc/httpd/conf.d/proxy.conf
echo "ProxyPass /rest ajp://$restIp:8009/rest" | sudo tee -a /etc/httpd/conf.d/proxy.conf


sudo sed -i "s/^error_reporting\s*=.*/error_reporting= E_ALL/" /etc/php.ini
sudo sed -i "s/^display_errors\s*=.*/display_errors = On/" /etc/php.ini
sudo sed -i "s/^display_startup_errors\s*=.*/display_startup_errors = On/" /etc/php.ini
sudo sed -i "s/^html_errors\s*=.*/display_html_errors = On/" /etc/php.ini
sudo sed -i "s/^log_errors\s*=.*/log_errors = On/" /etc/php.ini

#Load Shibconfig
echo "#Loading the Shibboleth module." | sudo tee -a /etc/httpd/conf.d/shib.conf
echo "LoadModule mod_shib /opt/shibboleth-sp/lib/shibboleth/mod_shib_24.so" | sudo tee -a /etc/httpd/conf.d/shib.conf
echo "#Ensure handler will be accessible." | sudo tee -a /etc/httpd/conf.d/shib.conf
echo "<Location /Shibboleth.sso>" | sudo tee -a /etc/httpd/conf.d/shib.conf
echo "  Satisfy Any" | sudo tee -a /etc/httpd/conf.d/shib.conf
echo "  Allow from all" | sudo tee -a /etc/httpd/conf.d/shib.conf
echo "</Location>" | sudo tee -a /etc/httpd/conf.d/shib.conf
echo "#StyleSheet for error templates." | sudo tee -a /etc/httpd/conf.d/shib.conf
echo "<IfModule mod_alias.c>" | sudo tee -a /etc/httpd/conf.d/shib.conf
echo "  <Location /shibboleth-sp>" | sudo tee -a /etc/httpd/conf.d/shib.conf
echo "    Satisfy Any" | sudo tee -a /etc/httpd/conf.d/shib.conf
echo "    Allow from all" | sudo tee -a /etc/httpd/conf.d/shib.conf
echo "  </Location>" | sudo tee -a /etc/httpd/conf.d/shib.conf
echo "  Alias /shibboleth-sp/main.css /opt/shibboleth-sp/share/shibboleth/main.css" | sudo tee -a /etc/httpd/conf.d/shib.conf
echo "</IfModule>" |sudo tee -a /etc/httpd/conf.d/shib/conf
echo "#Main shib module configuration." | sudo tee -a /etc/httpd/conf.d/shib.conf
echo "<Location />" | sudo tee -a /etc/httpd/conf.d/shib.conf
echo "  AuthTYpe shibboleth" | sudo tee -a /etc/httpd/conf.d/shib.conf
echo "  require shibboleth" | sudo tee -a /etc/httpd/conf.d/shib.conf
echo "  ShibUseHeaders On" | sudo tee -a /etc/httpd/conf.d/shib.conf
echo "</Location>" | sudo tee -a /etc/httpd/conf.d/shib.conf

#Install Shibboleth RPM
sudo yum -y install https://s3.amazonaws.com/dmc-build-aritifacts/Shibboleth/rpms/rh_httpd24_shibsp-1.0.0-1.x86_64.rpm
sudo cp /opt/shibboleth-sp/etc/shibboleth/shibd-redhat /etc/init.d/shibd
sudo chmod 755 /etc/init.d/shibd
sudo /sbin/chkconfig --add shibd
sudo /sbin/chkconfig --level 2345 shibd on
sudo /sbin/service shibd start



sudo mkdir -p /var/www/html
cd /tmp


sudo rm -fr /tmp/dist*
wget https://s3.amazonaws.com/dmc-build-aritifacts/$dmcreleasever/dmcfront/dist$dmcfrontdistver.tar.gz
mkdir dist
tar -xvzf dist$dmcfrontdistver.tar.gz -C dist

  ## update the version
  cd dist/templates/common/footer
  timestamp=`date --rfc-3339=seconds`
  sudo sed -i.bak "s|2015 Digital Manufacturing Commons|2015 Digital Manufacturing Commons version: $timestamp  |" footer-tpl.html

sudo cp -r /tmp/dist/* /var/www/html
cd /var/www/html/templates/common/header
if [ $dmcenvmode == development ] ; then
  echo "System is set up for Develpment Mode."
  sudo sed -i.bak "s|loginURL|https://apps.cirrusidentity.com/console/ds/index?entityID=https://dev-web1.opendmc.org/shibboleth\&return=https://$dmcURL/Shibboleth.sso/Login%3Ftarget%3Dhttps%3A%2F%2F$dmcURL|" header-tpl.html
else
  sudo sed -i.bak "s|loginURL|https://apps.cirrusidentity.com/console/ds/index?entityID=https://beta.opendmc.org/shibboleth\&return=https://$dmcURL/Shibboleth.sso/Login%3Ftarget%3Dhttps%3A%2F%2F$dmcURL|" header-tpl.html
  sudo sed -i.bak "s|dev-web1|beta|" /opt/shibboleth-sp/etc/shibboleth/shibboleth2.xml
  sudo wget https://s3.amazonaws.com/dmc-build-aritifacts/Shibboleth/prodcertificate/sp-prod-cert.pem -O /opt/shibboleth-sp/etc/shibboleth/sp-cert.pem
  sudo wget https://s3.amazonaws.com/dmc-build-aritifacts/Shibboleth/prodcertificate/sp-prod-key.pem -O /opt/shibboleth-sp/etc/shibboleth/sp-key.pem
fi


cd /var/www/html/scripts/common/models/
sudo sed -i.bak "s|  var creds = {bucket: '', access_key: '',secret_key: ''}|  var creds = {bucket: '$AWS_UPLOAD_BUCKET', access_key: '$AWS_UPLOAD_KEY',secret_key: '$AWS_UPLOAD_SEC'}|" file-upload.js
sudo sed -i.bak "s|    AWS.config.region = '';|    AWS.config.region = '$AWS_UPLOAD_REGION';|" file-upload.js
cd /var/www/html
sudo sed -i.bak "s|window.apiUrl = '';|window.apiUrl='https://$dmcURL/rest'|" *.php
sudo chown -R apache:apache /var/www/html
sudo /sbin/service shibd start
sudo /sbin/service httpd start
