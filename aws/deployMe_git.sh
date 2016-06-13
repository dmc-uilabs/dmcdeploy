#!/bin/bash -v
#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1
#yum update -y
yum install git -y

cd /tmp/
mkdir test
cd test
git init --bare my-project.git
cd my-project.git
echo "The git server is up :)" > hello.txt
git init
git add -A 
git commit -m "Initial commit"


echo " hello "
