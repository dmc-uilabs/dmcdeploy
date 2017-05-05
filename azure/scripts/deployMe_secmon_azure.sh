#!/bin/bash -v
#anything printed on stdout and stderr to be sent to the syslog1, as well as being echoed back to the original shell’s stderr.
exec 1> >(logger -s -t $(basename $0)) 2>&1

#### EXPECTED ENV VARIABLES AND FILES* ####
# * Files expected to be in home path
# # ALEX: configs assume semon is at 10.0.14.6
# LOGSTASH CONFIG FILES:
#     - 02-filebeat-input.conf
#     - 10-suricata-filter.conf
#     - 10-syslog-filter.conf
#     - 30-elasticsearch-output.conf
# LOGSTASH CERT GENERATION FILES:
#     - logstash-ca.conf
# NGINX CONFIG FILE FOR KIBANA:
#     - kibana.conf
# FILEBEAT CONFIG FILE (specific for each server):
#     - filebeat.yml +
# METRICBEAT CONFIG FILE (specific for each server):
#     - metricbeat.yml +
# ELASTALERT CONFIG FILES:
#     - config.yaml
#     - smtp_auth_file.yaml
#     - supervisord.conf
# SURICATA CONFIG FILES:
#     - suricata.yaml
# + naming convention in S3 bucket for metricbeat and filebeat: (metric|file)beat.servername.yml
#
# Env variables; ALEX: these need to be set by terra/whatever is calling this script
# NESSUS_KEY: key to connect to nessus web client
# NGINX_USERNAME: username for logging into kibana interface through nginx
# NGINX_PASSWORD: password for logging into kibana interface through nginx

# ALEX: this needs to be the responsibility of terra/whatever is calling this script
######### DISABLE SELINUX ################
#sudo sed -i 's/SELINUX=enforcing.*/SELINUX=disabled/' /etc/sysconfig/selinux
#sudo shutdown -r now
##########################################


######## GRAB CONFIG FILES ###############
# Grab files listed above from S3 bucket
# Change (metric|file)beat.servername.yml to (metric|file)beat.yml
mv metricbeat.secmon.yml metricbeat.yml
mv filebeat.secmon.yml filebeat.yml
#mv packetbeat.secmon.yml packetbeat.yml
##########################################


####### INSTALL ELASTICSEARCH ############
# No modifications need to be made to the configuration - can be run as is
sudo yum install -y java-1.8.0-openjdk
curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.3.2.rpm
sudo rpm -i elasticsearch-5.3.2.rpm
sudo service elasticsearch start
##########################################


######### CREATE TLS CERTS ###############
mkdir /tmp/logstash
cp logstash-ca.conf /tmp/logstash
cd /tmp/logstash
echo -e "US\nIllinois\nChicago\nUILABS\nDMC\nLogstash\n.\n" | openssl req -newkey rsa:2048 -days 3650 -x509 -nodes -out root.crt
echo -e "US\nIllinois\nChicago\nUILABS\nDMC\nLogstash\n.\n\n.\n" | openssl req -newkey rsa:2048 -nodes -out logstash-forwarder.csr -keyout logstash-forwarder.key
#echo -e "US\nIllinois\nChicago\nUILABS\nDMC\nLogstash\n.\n\n.\n" | openssl req -newkey rsa:2048 -nodes -out logstash-server.csr -keyout logstash-server.key
echo 000a > serialfile
touch certindex

#STACKMON_IP=$(ifconfig eth0 | grep "inet " | cut -d ' ' -f 10)

openssl ca -batch -config logstash-ca.conf -notext -in logstash-forwarder.csr -out logstash-forwarder.crt
#openssl ca -batch -config logstash-ca.conf -notext -in logstash-server.csr -out logstash-server.crt
sudo mv logstash-forwarder.crt /etc/pki/tls/certs
sudo mv logstash-forwarder.key /etc/pki/tls/private
#sudo mv logstash-server.crt /etc/pki/tls/certs
#sudo mv logstash-server.key /etc/pki/tls/private

sudo yum install -y ca-certificates
sudo update-ca-trust force-enable
sudo mv root.crt /etc/pki/ca-trust/source/anchors
sudo update-ca-trust extract

cd ..
rm -r logstash
cd ~

# ALEX: copy /etc/pki/ca-trust/source/anchors/root.crt to s3
##########################################


######### INSTALL LOGSTASH ###############
sudo yum install java-1.8.0-openjdk
curl -L -O https://artifacts.elastic.co/downloads/logstash/logstash-5.3.2.rpm
sudo rpm -i logstash-5.3.2.rpm

# Configure logstash startup script to pass log verbosity option
sudo sed -i 's/LS_OPTS=.*/LS_OPTS=\"--path.settings ${LS_SETTINGS_DIR} --log.level error\"/' /etc/logstash/startup.options
sudo /usr/share/logstash/bin/system-install

# Copy configuration to logstash config folder
sudo mv 02-filebeat-input.conf /etc/logstash/conf.d
sudo mv 10-syslog-filter.conf /etc/logstash/conf.d
sudo mv 10-suricata-filter.conf /etc/logstash/conf.d
sudo mv 30-elasticsearch-output.conf /etc/logstash/conf.d

# Start logstash
sudo service logstash start
##########################################


########## INSTALL KIBANA ################
# No modifications need to be made to the configuration - can be run as is
wget https://artifacts.elastic.co/downloads/kibana/kibana-5.3.2-x86_64.rpm
sudo rpm --install kibana-5.3.2-x86_64.rpm
sudo service kibana start
##########################################


########## INSTALL NGINX #################
sudo yum install -y epel-release
sudo yum install -y nginx

# Remove default server config
sudo sed -i '38,57d' /etc/nginx/nginx.conf

# Copy config for kibana
sudo mv kibana.conf /etc/nginx/conf.d

# Create auth file for http authentication
sudo yum install -y httpd-tools
echo -e "$NGINX_PASSWORD" | sudo htpasswd -i -c /etc/nginx/htpasswd.users $NGINX_USERNAME

sudo setenforce 0

sudo service nginx start
##########################################

# ALEX: (stackmon.opendmc.org - update cloudflare dns entry with public ip)


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


######## INSTALL PACKETBEAT ##############
# sudo yum install libpcap
# curl -L -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-5.4.0-x86_64.rpm
# sudo rpm -vi packetbeat-5.4.0-x86_64.rpm
# 
# sudo mv packetbeat.yml /etc/packetbeat/packetbeat.yml
# sudo chmod 644 /etc/packetbeat/packetbeat.yml
# sudo chown root /etc/packetbeat/packetbeat.yml
# sudo chgrp root /etc/packetbeat/packetbeat.yml
# 
# sudo service packetbeat start
##########################################


######## INSTALL SURICATA ################
# Install dependencies
sudo yum install -y epel-release
sudo yum -y install gcc libpcap-devel pcre-devel libyaml-devel file-devel \
  zlib-devel jansson-devel nss-devel libcap-ng-devel libnet-devel tar make \
  libnetfilter_queue-devel lua-devel

# Install and configure suricata
wget http://www.openinfosecfoundation.org/download/suricata-3.1.tar.gz
tar -xvzf suricata-3.1.tar.gz
cd suricata-3.1
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --enable-nfqueue --enable-lua
sudo make
sudo make install-full
sudo ldconfig

# Copy suricata config file to suricata directory
sudo mkdir /var/log/suricata
sudo mkdir /etc/suricata
sudo cp classification.config /etc/suricata
sudo cp reference.config /etc/suricata
sudo cp -r rules /etc/suricata
cd ~
sudo mv suricata.yaml /etc/suricata

# Start suricata
sudo suricata -D -c /etc/suricata/suricata.yaml -i eth0 --init-errors-fatal
##########################################


####### INSTALL ELASTALERT ###############
# Install dependencies and elastalert
sudo yum install -y git
sudo yum install -y python-pip
sudo yum install -y openssl
sudo yum install -y openssl-devel
git clone https://github.com/Yelp/elastalert.git
sudo mv elastalert /etc
cd /etc/elastalert
sudo -H pip install -U pip setuptools
sudo yum group install -y 'Development Tools'
sudo yum install -y python-devel
sudo python setup.py install
sudo pip install -r requirements-dev.txt
sudo pip install "elasticsearch>=5.0.0"
sudo pip install twilio==6.0.0

# Create elasalert index in elasticsearch
elastalert-create-index --host localhost --port 9200 --no-auth --no-ssl --index elastalert_status --url-prefix "" --old-index ""

# Copy config files to elastalert directory
cd ~
mv config.yaml /etc/elastalert
mv smtp_auth_file.yaml /etc/elastalert

# Install and configure supervisord for running elastalert
sudo easy_install supervisor
sudo mv supervisord.conf /etc

# Start supervisord which starts elastalert
supervisord
##########################################


######### INSTALL NESSUS #################
curl -s -L https://github.com/ericchiang/pup/releases/download/v0.4.0/pup_v0.4.0_linux_amd64.zip | funzip | sudo tee /usr/local/bin/pup >/dev/null; sudo chmod 755 /usr/local/bin/pup
TOKEN=`curl -s https://www.tenable.com/products/nessus/agent-download | pup 'div#timecheck text{}'`
curl -L -s "http://downloads.nessus.org/nessus3dl.php?file=NessusAgent-6.10.5-es7.x86_64.rpm&licence_accept=yes&t=$TOKEN" -o /tmp/nessus.rpm
sudo rpm -i /tmp/nessus.rpm
sudo /opt/nessus_agent/sbin/nessuscli agent link --key=$NESSUS_KEY --group="group1" --port=443 --host=cloud.tenable.com
sudo /bin/systemctl start nessusagent.service
##########################################

