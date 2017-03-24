#!/bin/bash


stackmontype=$1

secmon_pkgs () {
     sudo yum -y install suricata jansson unzip
}


suricata_base () {
      sudo sed -i 's|linux: \[|linux: \[10.0.0.0\/8|g' /etc/suricata/suricata.yaml
      sudo sed -i 's|windows: \[0.0.0.0\/0|windows: \[|g' /etc/suricata/suricata.yaml
      sudo /sbin/ethtool -K eth0 sg off gro off lro off tso off gso off
      sudo chmod -R 777 /etc/suricata
      cd /etc/suricata/rules
      sudo touch ciarmy.rules compromised.rules drop.rules dshield.rules emerging-attack_response.rules emerging-chat.rules emerging-current_events.rules emerging-dns.rules emerging-dos.rules emerging-exploit.rules emerging-ftp.rules emerging-imap.rules emerging-malware.rules emerging-misc.rules emerging-mobile_malware.rules emerging-netbios.rules emerging-p2p.rules emerging-policy.rules emerging-pop3.rules emerging-rpc.rules emerging-scada.rules emerging-scan.rules emerging-smtp.rules emerging-snmp.rules emerging-sql.rules emerging-telnet.rules emerging-tftp.rules emerging-trojan.rules emerging-user_agents.rules emerging-voip.rules emerging-web_client.rules emerging-web_server.rules emerging-worm.rules tor.rules
      cd ~
      sudo chmod -R 750 /etc/suricata
      sudo systemctl enable suricata
      sudo systemctl start suricata
}

elkpkg () {
#      sudo yum -y install https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.2.2.rpm
      sudo yum -y install https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.2.2-x86_64.rpm
#      sudo yum -y install https://artifacts.elastic.co/downloads/kibana/kibana-5.2.2-x86_64.rpm
#      sudo yum -y install https://artifacts.elastic.co/downloads/logstash/logstash-5.2.2.rpm
}

#elkxpackbase () {
#       #echo network.host: localhost | sudo tee -a /etc/elasticsearch/elasticsearch.yml
#       #echo xpack.security.authc.realms.native1.type: native | sudo tee -a /etc/elasticsearch/elasticsearch.yml
#       #echo xpack.security.audit.enabled: true| sudo tee -a /etc/elasticsearch/elasticsearch.yml
#       #sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install x-pack -b
#}

elkconfig () {
      echo network.host: localhost | sudo tee -a /etc/elasticsearch/elasticsearch.yml
      sudo sed -i 's|\# server.host: \"0.0.0.0\"|server.host: \"localhost\"|' /etc/kibana/kibana.yml
      sudo chmod 777 /etc/logstash/conf.d
      cp /tmp/*-*.conf /etc/logstash/conf.d

}

elkenable () {
#      sudo systemctl daemon-reload
#      sudo systemctl enable elasticsearch
#      sudo systemctl start elasticsearch
      sudo systemctl enable suricata
      sudo systemctl start suricata
      sudo systemctl enable filebeat
      sudo systemctl start filebeat
#      sudo systemctl enable logstash
#      sudo systemctl start logstash
#      sudo systemctl enable kibana
#      sudo systemctl start kibana
}

elkdash () {
     sudo setenforce 0
     sudo setsebool -P httpd_can_network_connect 1
#     sudo sed -i.bak 's|SELINUX=enforcing|SELINUX=disabled|' /etc/selinux/config
     cd ~
     wget https://download.elastic.co/beats/dashboards/beats-dashboards-1.1.0.zip
     wget https://gist.githubusercontent.com/thisismitch/3429023e8438cc25b86c/raw/d8c479e2a1adcea8b1fe86570e42abab0f10f364/filebeat-index-template.json
     unzip beats-dashboards-1.1.0.zip
     cd beats-dashboards-*
     ./load.sh
     curl -XPUT 'http://localhost:9200/_template/filebeat?pretty' -d@../filebeat-index-template.json

}


nginxprep() {
     sudo sed -i '/\\[ v3_ca \\]/a subjectAltName=IP:10.0.14.4' /etc/pki/tls/openssl.cnf
     sudo openssl req -config /etc/pki/tls/openssl.cnf -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout /etc/pki/tls/private/logstash-forwarder.key -out /etc/pki/tls/certs/logstash-forwarder.crt
     sudo chmod 777 /etc/nginx/conf.d
     sudo sed -i.bak '38,56d;89,90d' /etc/nginx/nginx.conf
     cp /tmp/kibana.conf /etc/nginx/nginx.conf
     sudo systemctl start nginx
}

wrapper() {
  secmon_pkgs
  elkpkg
  suricata_base
#  elkconfig
  elkenable
#  elkdash
#  nginxprep
}

wrapper
