#!/bin/bash -v


sudo yum install -y git-all



cd /opt

git clone https://github.com/dmc-uilabs/dmcvalidation.git
cd dmcvalidation
source /etc/profile.d/dmc.sh

npm install

pm2 start validate.js -i max
