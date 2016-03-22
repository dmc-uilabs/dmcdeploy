#!/bin/bash -v

#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1

    #sudo yum update -y
 sudo yum update -y
function buildAMIBase {
    #install needed packages
   
    sudo yum install -y java-1.8.0-openjdk.x86_64
    sudo yum erase -y java-1.7.0-openjdk
    sudo yum install -y git
    sudo yum install -y tomcat7
    sudo yum install wget -y
    sudo yum remove sendmail -y
   
}



##command to create the AMI base
buildAMIBase

# remove unneeded software

