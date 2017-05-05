#!/bin/bash -v
#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1
# Need: filebeat.yml, metricbeat.yml, root.crt

######## GRAB CONFIG FILES ###############
# Grab files from S3 bucket
# Change (metric|file)beat.servername.yml to (metric|file)beat.yml
mv metricbeat.secmon.yml metricbeat.yml
mv filebeat.secmon.yml filebeat.yml
#mv packetbeat.secmon.yml packetbeat.yml

# Install CA cert for communication with logstash
sudo yum install -y ca-certificates
sudo update-ca-trust force-enable
sudo mv root.crt /etc/pki/ca-trust/source/anchors
sudo update-ca-trust extract
##########################################


######## INSTALL FILEBEAT ################
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.3.2-x86_64.rpm
sudo rpm -vi filebeat-5.3.2-x86_64.rpm

# Copy config for filebeat and change permissions for filebeat constraints
sudo mv filebeat.yml /etc/filebeat/
sudo chmod 644 /etc/filebeat/filebeat.yml
sudo chown root /etc/filebeat/filebeat.yml
sudo chgrp root /etc/filebeat/filebeat.yml

sudo service filebeat start
##########################################


######## INSTALL METRICBEAT ##############
curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-5.3.2-x86_64.rpm
sudo rpm -vi metricbeat-5.3.2-x86_64.rpm

# Copy config for metricbeat and change permissions for metricbeat constraints
sudo mv metricbeat.yml /etc/metricbeat/metricbeat.yml
sudo chmod 644 /etc/metricbeat/metricbeat.yml
sudo chown root /etc/metricbeat/metricbeat.yml
sudo chgrp root /etc/metricbeat/metricbeat.yml

sudo service metricbeat start
##########################################