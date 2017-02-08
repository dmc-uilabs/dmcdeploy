resource "null_resource" "secmonProvision" {
  depends_on = ["azurerm_virtual_machine.secmon"]


  provisioner "remote-exec" {
       inline = [
        "sudo yum -y install epel-release, java-1.8.0-openjdk",
        "sudo yum -y install https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/rpm/elasticsearch/2.4.4/elasticsearch-2.4.4.rpm",
        "sudo yum -y install https://download.elastic.co/kibana/kibana/kibana-4.6.4-x86_64.rpm",
        "sudo yum -y install https://download.elastic.co/logstash/logstash/packages/centos/logstash-2.4.1.noarch.rpm",
        "sudo yum -y install epel-release",
        "sudo yum -y install suricata jansson unzip nginx httpd-tools",
        "sudo sed -i 's|windows: \\[0.0.0.0\\/0|windows: \\[|g' /etc/suricata/suricata.yaml",
        "sudo sed -i 's|linux: \\[|linux: \\[10.0.0.0\\/8|g' /etc/suricata/suricata.yaml",
        "sudo /sbin/ethtool -K eth0 sg off gro off lro off tso off gso off",
        "sudo chmod -R 777 /etc/suricata",
        "cd /etc/suricata/rules",
	"sudo touch ciarmy.rules compromised.rules drop.rules dshield.rules emerging-attack_response.rules emerging-chat.rules emerging-current_events.rules emerging-dns.rules emerging-dos.rules emerging-exploit.rules emerging-ftp.rules emerging-imap.rules emerging-malware.rules emerging-misc.rules emerging-mobile_malware.rules emerging-netbios.rules emerging-p2p.rules emerging-policy.rules emerging-pop3.rules emerging-rpc.rules emerging-scada.rules emerging-scan.rules emerging-smtp.rules emerging-snmp.rules emerging-sql.rules emerging-telnet.rules emerging-tftp.rules emerging-trojan.rules emerging-user_agents.rules emerging-voip.rules emerging-web_client.rules emerging-web_server.rules emerging-worm.rules tor.rules",
        "cd ~",
        "sudo chmod -R 750 /etc/suricata",
        "echo network.host: localhost | sudo tee -a /etc/elasticsearch/elasticsearch.yml",
        "sudo systemctl daemon-reload",
        "sudo systemctl enable elasticsearch",
        "sudo systemctl start elasticsearch",
        "sudo sed -i 's|\\# server.host: \"0.0.0.0\"|server.host: \"localhost\"|' /opt/kibana/config/kibana.yml",
        "sudo systemctl start kibana",
	"sudo sed -i.bak '38,56d;89,90d' /etc/nginx/nginx.conf",
        "sudo htpasswd -cBb /etc/nginx/htpasswd.users ${var.stackmonwebuser} ${var.stackmonwebpass}",
        "sudo sed -i '/\\[ v3_ca \\]/a subjectAltName=IP:${azurerm_network_interface.secmonInt.private_ip_address}' /etc/pki/tls/openssl.cnf",
        "sudo openssl req -config /etc/pki/tls/openssl.cnf -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout /etc/pki/tls/private/logstash-forwarder.key -out /etc/pki/tls/certs/logstash-forwarder.crt",
	"sudo chmod 777 /etc/logstash/conf.d",
	"sudo chmod 777 /etc/nginx/conf.d"
       ]

       connection {
           host = "${azurerm_public_ip.secmonPubIp.ip_address}"
           user = "${var.dmcUser}"
           private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
       }
  }

  provisioner "file" {
      source = "configs/secmon/02-beats-input.conf"
      destination = "/etc/logstash/conf.d/02-beats-input.conf"

      connection {
          host = "${azurerm_public_ip.secmonPubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }

  provisioner "file" {
      source = "configs/secmon/10-syslog-filter.conf"
      destination = "/etc/logstash/conf.d/10-syslog-filter.conf"

      connection {
          host = "${azurerm_public_ip.secmonPubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }

  provisioner "file" {
        source = "configs/secmon/30-elasticsearch-output.conf"
        destination = "/etc/logstash/conf.d/30-elasticsearch-output.conf"

        connection {
            host = "${azurerm_public_ip.secmonPubIp.ip_address}"
            user = "${var.dmcUser}"
            private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
        }
  }

  provisioner "file" {
        source = "configs/secmon/kibana.conf"
        destination = "/etc/nginx/conf.d/kibana.conf"

        connection {
            host = "${azurerm_public_ip.secmonPubIp.ip_address}"
            user = "${var.dmcUser}"
            private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
        }
  }

  provisioner "remote-exec" {
       inline = [
         "sudo systemctl enable nginx",
         "sudo systemctl start nginx",
         "sudo setenforce 0",
         "sudo setsebool -P httpd_can_network_connect 1",
         "sudo sed -i.bak 's|SELINUX=enforcing|SELINUX=disabled|' /etc/selinux/config",
         "cd ~",
         "wget https://download.elastic.co/beats/dashboards/beats-dashboards-1.1.0.zip",
         "wget https://gist.githubusercontent.com/thisismitch/3429023e8438cc25b86c/raw/d8c479e2a1adcea8b1fe86570e42abab0f10f364/filebeat-index-template.json",
         "unzip beats-dashboards-1.1.0.zip",
	 "cd beats-dashboards-*",
         "./load.sh",
         "curl -XPUT 'http://localhost:9200/_template/filebeat?pretty' -d@../filebeat-index-template.json",
         "sudo systemctl restart elasticsearch",
         "sudo systemctl restart kibana",
         "sudo systemctl restart logstash"
       ]
       
       connection {
           host = "${azurerm_public_ip.secmonPubIp.ip_address}"
           user = "${var.dmcUser}"
           private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
       }
  }

}
