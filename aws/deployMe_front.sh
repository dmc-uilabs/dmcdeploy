#!/bin/bash -v

### NEEDED Variables
# $createNewAMI
# $serverURL
##########

#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1

# sudo yum update

source ./deployME_front_functions.sh

##set the appropriate level of logging
setLogLevel
configureShibolethApache
configureShibbolethServiceProvider

##command to install from latest auto build from bamboo -- cannot be used to install particular release
configureApache
## used to redirect traffic from HTTP to HTTPS
httpToHttpsRewrite

## add rest services proxy configuration
ajpProxy

moveShibbolethServiceProviderKeys

installWebsite

cd /tmp/dist/templates/common/header
echo "set loginURL to $loginURL "
setLoginUrl

cd /tmp/dist/scripts/common/models/
frontendUpload

cd /tmp/dist/
commonInstallWebsiteConfig
##command to install from official DMC build repos -- used to install a particular release
#installWebsiteDMCrepos

# start apache then shibboleth
sudo /opt/shibboleth-sp/sbin/shibd
sudo /etc/init.d/httpd start
