#!/bin/bash -v
#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1
#
# deployMe.sh for Apache Solr
#

sudo yum remove sendmail -y
sudo yum install git -y
