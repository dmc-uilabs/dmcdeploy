resource "null_resource" "dbProvision" {
  depends_on = ["azurerm_virtual_machine.db"]

provisioner "file" {
    source = "scripts/deployMe_db_azure.sh"
    destination = "/tmp/script.sh"

    connection {
        host = "${azurerm_public_ip.dbPubIp.ip_address}"
        user = "${var.dmcUser}"
        private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
    }
}

provisioner "file" {
      source = "scripts/deployMe_oscheck.sh"
      destination = "/tmp/oscheck.sh"

      connection {
          host = "${azurerm_public_ip.dbPubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }

provisioner "file" {
      source = "configs/secmon/filebeat.zip"
      destination = "/tmp/filebeat.zip"

      connection {
          host = "${azurerm_public_ip.dbPubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }


provisioner "remote-exec" {
  inline = ["bash -x /tmp/oscheck.sh 2>&1 | tee /tmp/out2.log"]
  connection {
     host = "${azurerm_public_ip.dbPubIp.ip_address}"
     user = "${var.dmcUser}"
     private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
  }
}

provisioner "file" {
      source = "scripts/deployMe_nessus.sh"
      destination = "/tmp/deployMe_nessus.sh"

      connection {
          host = "${azurerm_public_ip.dbPubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }

provisioner "remote-exec" {
  inline = ["bash -x /tmp/deployMe_nessus.sh ${var.nessusapikey} ${azurerm_resource_group.resource.name} 2>&1 | tee /tmp/out3.log"]
  connection {
     host = "${azurerm_public_ip.dbPubIp.ip_address}"
     user = "${var.dmcUser}"
     private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
  }
}



provisioner "remote-exec" {
       inline = [
        "sudo systemctl stop firewalld",
        "sudo systemctl disable firewalld",
        "cd /tmp",
        "unzip /tmp/filebeat.zip",
        "cd /tmp/filebeat",
        "sudo yum -y install https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.2.2-x86_64.rpm",
        "sudo cp * /etc/filebeat",
        "sudo yum install -y java-1.8.0-openjdk",
        "sudo yum install -y http://ftp.postgresql.org/pub/repos/yum/9.4/redhat/rhel-6.7-x86_64/pgdg-redhat94-9.4-3.noarch.rpm",
        "sudo yum install -y postgresql94-server postgresql94-contrib",
        "sudo rm -rf /var/lib/pgsql/9.4/*",
        "sudo /usr/pgsql-9.4/bin/postgresql94-setup initdb",
        "echo include_dir = 'conf.d' sudo tee -a /var/lib/pgsql/9.4/postgresql.conf",
        "echo export PSQLUSER=${var.psqlUser} | sudo tee  /etc/profile.d/dmc.sh",
        "echo export PSQLPASS=${var.psqlPass} | sudo tee -a /etc/profile.d/dmc.sh",
        "echo export DB=${var.psqlDb} | sudo tee -a /etc/profile.d/dmc.sh",
        "echo export mode=${var.mode} | sudo tee -a /etc/profile.d/dmc.sh",
        "chmod +x /tmp/script.sh",
        "cd /tmp",
        "bash -x script.sh 2>&1 | tee out.log"
       ]

       connection {
           host = "${azurerm_public_ip.dbPubIp.ip_address}"
           user = "${var.dmcUser}"
           private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
       }
}




}
