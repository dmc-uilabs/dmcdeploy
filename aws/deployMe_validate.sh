#!/bin/bash
#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1


cd ~
### baseimage stuffs

#install nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash
#refresh the current shell
source /home/ec2-user/.bashrc

#install node
nvm install v5.1.1

#install calmav
sudo yum install -y clamav clamav-update

#edit the clamav configuration
sudo sed -i '5,/Example/s/Example/#Example/' /etc/freshclam.conf


#update the antivirus db
#sudo freshclam




#install forever to allow for node script to run as a service
npm install -g pm2



#install git
sudo yum install -y git

###

#clone the validation repo
git clone https://bitbucket.org/DigitalMfgCommons/validation.git

cd validation


#update the antivirus db
#sudo freshclam


npm install



#will start and maintain the service
pm2 start validate.js -i max

#to see running procesess
#pm2 list
