#!/bin/bash -v

#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1

     sudo yum update -y
function buildAMIBase {
    #install needed packages
        sudo yum remove sendmail -y
        sudo yum install git -y

        # download postgress
        sudo yum -y install postgresql94.x86_64 postgresql94-server.x86_64 postgresql94-contrib.x86_64 git

 
}



##command to create the AMI base
buildAMIBase

# remove unneeded software

