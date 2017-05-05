#!/bin/bash -v
#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1

# THIS SCRIPT REQUIRES THE FOLLOWING:
# FILES:
#    - filebeat.<hostname>.yml
#    - metricbeat.<hostname>.yml
#    - root.crt
# ENV VARS:
#    - NESSUS_KEY

VERSION=$(cat /proc/version)
if [[ $VERSION == *"Ubuntu"* ]]; then
  VERSION="Ubuntu"
else 
  VERSION="RHEL"
fi

######## GRAB CONFIG FILES ###############
# Grab files from S3 bucket
# Change (metric|file)beat.servername.yml to (metric|file)beat.yml
HOSTNAME=$(hostname | cut -d. -f1)
mv metricbeat.$HOSTNAME.yml metricbeat.yml
mv filebeat.$HOSTNAME.yml filebeat.yml
#mv packetbeat.secmon.yml packetbeat.yml

# Install CA cert for communication with logstash
if [ $VERSION == "RHEL" ]; then
  sudo yum install -y ca-certificates
  sudo update-ca-trust force-enable
  sudo mv root.crt /etc/pki/ca-trust/source/anchors
  sudo update-ca-trust extract
else
  sudo mv root.crt /usr/share/ca-certificates/
  echo "root.crt" | sudo tee --append /etc/ca-certificates.conf
  sudo update-ca-certificates
fi
##########################################


######## INSTALL FILEBEAT ################
if [ $VERSION == "RHEL" ]; then
  curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.3.2-x86_64.rpm
  sudo rpm -vi filebeat-5.3.2-x86_64.rpm
else
  curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.4.0-amd64.deb
  sudo dpkg -i filebeat-5.4.0-amd64.deb
fi

# Copy config for filebeat and change permissions for filebeat constraints
sudo mv filebeat.yml /etc/filebeat/
sudo chmod 644 /etc/filebeat/filebeat.yml
sudo chown root /etc/filebeat/filebeat.yml
sudo chgrp root /etc/filebeat/filebeat.yml

sudo service filebeat start
##########################################


######## INSTALL METRICBEAT ##############
if [ $VERSION == "RHEL" ]; then
  curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-5.3.2-x86_64.rpm
  sudo rpm -vi metricbeat-5.3.2-x86_64.rpm
else
  curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-5.4.0-amd64.deb
  sudo dpkg -i metricbeat-5.4.0-amd64.deb
fi

# Copy config for metricbeat and change permissions for metricbeat constraints
sudo mv metricbeat.yml /etc/metricbeat/metricbeat.yml
sudo chmod 644 /etc/metricbeat/metricbeat.yml
sudo chown root /etc/metricbeat/metricbeat.yml
sudo chgrp root /etc/metricbeat/metricbeat.yml

sudo service metricbeat start
##########################################


######### INSTALL NESSUS #################
curl -s -L https://github.com/ericchiang/pup/releases/download/v0.4.0/pup_v0.4.0_linux_amd64.zip | funzip | sudo tee /usr/local/bin/pup >/dev/null; sudo chmod 755 /usr/local/bin/pup
TOKEN=`curl -s https://www.tenable.com/products/nessus/agent-download | pup 'div#timecheck text{}'`

if [ $VERSION == "RHEL" ]; then
  curl -L -s "http://downloads.nessus.org/nessus3dl.php?file=NessusAgent-6.10.5-es7.x86_64.rpm&licence_accept=yes&t=$TOKEN" -o /tmp/nessus.rpm
  sudo rpm -i /tmp/nessus.rpm
else
  curl -L -s "http://downloads.nessus.org/nessus3dl.php?file=NessusAgent-6.10.5-ubuntu1110_amd64.deb&licence_accept=yes&t=$TOKEN" -o /tmp/nessus.deb
  sudo dpkg -i /tmp/nessus.deb
fi

sudo /opt/nessus_agent/sbin/nessuscli agent link --key=$NESSUS_KEY --group="group1" --port=443 --host=cloud.tenable.com
sudo /bin/systemctl start nessusagent.service
##########################################