#!/bin/bash -v

#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1

    #sudo yum update -y
 sudo yum update -y
function buildAMIBase {
    #install needed packages
    wget http://mirror.cc.columbia.edu/pub/software/apache/activemq/5.13.2/apache-activemq-5.13.2-bin.tar.gz
    tar zxvf apache-activemq-5.13.2-bin.tar.gz

    sudo mv apache-activemq-5.13.2 /opt
    sudo ln -sf /opt/apache-activemq-5.13.2/ /opt/activemq
    sudo yum install git -y

}



##command to create the AMI base
buildAMIBase

# remove unneeded software
