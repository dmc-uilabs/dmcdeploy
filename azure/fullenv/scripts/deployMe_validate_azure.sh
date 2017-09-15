#!/bin/bash -v


cd /opt

git clone https://github.com/dmc-uilabs/dmcvalidation.git
cd dmcvalidation
source /etc/profile.d/dmc.sh

npm install

pm2 start validate.js -i max


cd /opt

git clone https://github.com/dmc-uilabs/dmcEmail.git
cd dmcEmail
source /etc/profile.d/dmc.sh

npm install

pm2 start sendGrid.js -i max
