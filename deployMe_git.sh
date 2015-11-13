#!/bin/bash -v
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
