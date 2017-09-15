
resource "null_resource" "restProvision" {
    depends_on = ["azurerm_virtual_machine.rest","null_resource.activemqProvision","null_resource.dbProvision"]


  provisioner "file" {
      source = "scripts/deployMe_oscheck.sh"
      destination = "/tmp/os_script.sh"

      connection {
          host = "${azurerm_public_ip.restPubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }



    provisioner "file" {
        source = "scripts/deployMe_rest_azure.sh"
        destination = "/tmp/script.sh"

        connection {
            host = "${azurerm_public_ip.restPubIp.ip_address}"
            user = "${var.dmcUser}"
            private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
        }
    }


  provisioner "remote-exec" {
       inline = [
        "sudo bash -x /tmp/os_script.sh 2>&1 | tee -a /tmp/out.log ",
        "sudo yum install -y tomcat",
        "echo DBip=${azurerm_network_interface.dbInt.private_ip_address} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo DBport=${var.psqlPort} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo DBpass=${var.psqlPass} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo DBuser=${var.psqlUser} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo myIp=${azurerm_network_interface.restInt.private_ip_address} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo ActiveMQ_URL=${azurerm_network_interface.activeInt.private_ip_address} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo ActiveMQ_Port=${var.activeMqPort} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo ActiveMQ_User=admin| sudo tee -a /etc/tomcat/tomcat.conf",
        "echo ActiveMQ_Password=${var.activeMqRootPass} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo verifyURL=${azurerm_network_interface.validateInt.private_ip_address} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo AWS_UPLOAD_SEC=${var.awsRestSecret} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo AWS_UPLOAD_KEY=${var.awsRestKey} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo AWS_UPLOAD_BUCKET_FINAL=${var.awsUploadVerBucket} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo AWS_UPLOAD_BUCKET=${var.awsUploadBucket} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo dmcreleasever=${var.dmcreleasever} | sudo tee -a /etc/profile.d/dmc.sh",
	      "echo solrDbDns=http://${azurerm_network_interface.solrInt.private_ip_address}:${var.solrPort}/solr | sudo tee -a /etc/tomcat/tomcat.conf",
	      "echo SOLR_BASE_URL=http://${azurerm_network_interface.solrInt.private_ip_address}:${var.solrPort}/solr | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo STRIPE_T_SKEY=${var.stripeKey} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo ESIGN_KEY=${var.esign_key} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo ESIGN_DOCUMENT=${var.esign_document} | sudo tee -a /etc/tomcat/tomcat.conf",
        "chmod +x /tmp/script.sh",
        "cd /tmp",
        "bash -x script.sh 2>&1 | tee -a /tmp/out.log"
       ]

       connection {
           host = "${azurerm_public_ip.restPubIp.ip_address}"
           user = "${var.dmcUser}"
           private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
       }
  }
}
