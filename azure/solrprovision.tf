resource "null_resource" "solrProvision" {
  depends_on = ["azurerm_virtual_machine.solrvm","null_resource.dbProvision"]

  provisioner "file" {
    source = "./scripts/deployMe_solr_azure.sh"
    destination = "/tmp/script.sh"

    connection {
      host = "${azurerm_public_ip.solrPubIp.ip_address}"
      user = "${var.dmcUser}"
      private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
    }
  }

   provisioner "file" {
      source = "scripts/deployMe_oscheck.sh"
      destination = "/tmp/oscheck.sh"

      connection {
          host = "${azurerm_public_ip.solrPubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }

  provisioner "file" {
      source = "configs/secmon/filebeat.zip"
      destination = "/tmp/filebeat.zip"

      connection {
          host = "${azurerm_public_ip.solrPubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }


  provisioner "remote-exec" {
    inline = ["bash -x /tmp/oscheck.sh 2>&1 | tee /tmp/out2.log"]
    connection {
       host = "${azurerm_public_ip.solrPubIp.ip_address}"
       user = "${var.dmcUser}"
       private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
    }
 }

 provisioner "file" {
      source = "scripts/deployMe_nessus.sh"
      destination = "/tmp/deployMe_nessus.sh"

      connection {
          host = "${azurerm_public_ip.solrPubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }

provisioner "remote-exec" {
  inline = ["bash -x /tmp/deployMe_nessus.sh ${var.nessusapikey} 2>&1 | tee /tmp/out3.log"]
  connection {
     host = "${azurerm_public_ip.solrPubIp.ip_address}"
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
      "sudo echo export solrDbDns=${azurerm_network_interface.dbInt.private_ip_address} | sudo tee /etc/profile.d/dmc.sh",
      "echo export solrDbPort=5432 | sudo tee -a /etc/profile.d/dmc.sh",
      "echo export release=${var.release} | sudo tee -a /etc/profile.d/dmc.sh",
      "source /etc/profile.d/dmc.sh" ,
      "chmod +x /tmp/script.sh",
      "cd /tmp",
      "bash -x script.sh 2>&1 | tee out.log",

    ]

    connection {
      host = "${azurerm_public_ip.solrPubIp.ip_address}"
      user = "${var.dmcUser}"
      private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
    }
  }

}
