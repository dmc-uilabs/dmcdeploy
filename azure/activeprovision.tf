resource "null_resource" "activemqProvision" {
   depends_on = ["azurerm_virtual_machine.active"]

provisioner "file" {
      source = "scripts/deployMe_oscheck.sh"
      destination = "/tmp/oscheck.sh"

      connection {
          host = "${azurerm_public_ip.activePubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }

provisioner "remote-exec" {
  inline = ["bash -x /tmp/oscheck.sh 2>&1 | tee /tmp/out2.log"]
  connection {
     host = "${azurerm_public_ip.activePubIp.ip_address}"
     user = "${var.dmcUser}"
     private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
  }
}

provisioner "file" {
      source = "scripts/deployMe_activemq_azure.sh"
      destination = "/tmp/script.sh"

      connection {
          host = "${azurerm_public_ip.activePubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }

provisioner "file" {
      source = "configs/secmon/filebeat.zip"
      destination = "/tmp/filebeat.zip"

      connection {
          host = "${azurerm_public_ip.activePubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }

provisioner "file" {
      source = "scripts/deployMe_nessus.sh"
      destination = "/tmp/deployMe_nessus.sh"

      connection {
          host = "${azurerm_public_ip.activePubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }

provisioner "remote-exec" {
  inline = ["bash -x /tmp/deployMe_nessus.sh ${var.nessusapikey} 2>&1 | tee /tmp/out3.log"]
  connection {
     host = "${azurerm_public_ip.activePubIp.ip_address}"
     user = "${var.dmcUser}"
     private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
  }
}


  provisioner "remote-exec" {
         inline = [
          "cd /tmp",
          "unzip /tmp/filebeat.zip",
          "cd /tmp/filebeat",
          "sudo yum -y install https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.2.2-x86_64.rpm",
          "sudo cp * /etc/filebeat",
          "wget https://archive.apache.org/dist/activemq/5.13.4/apache-activemq-5.13.4-bin.tar.gz",
          "tar zxvf apache-activemq-5.13.4-bin.tar.gz",
          "sudo mv apache-activemq-5.13.4 /opt",
          "sudo ln -sf /opt/apache-activemq-5.13.4/ /opt/activemq",
          "echo export activeMqRootPass=${var.activeMqRootPass} | sudo tee -a /etc/profile.d/dmc.sh",
          "echo export activeMqUserPass=${var.activeMqUserPass} | sudo tee -a /etc/profile.d/dmc.sh",
          "chmod +x /tmp/script.sh",
          "cd /tmp",
          "bash -x script.sh 2>&1 | tee out.log"

         ]

         connection {
             host = "${azurerm_public_ip.activePubIp.ip_address}"
             user = "${var.dmcUser}"
             private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
         }
  }

}
