#!/bin/bash -v

#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1

    #sudo yum update -y

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
    
}



##command to create the AMI base
buildAMIBase

# remove unneeded software

