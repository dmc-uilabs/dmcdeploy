
resource "null_resource" "restProvision" {
    depends_on = ["azurerm_virtual_machine.rest","null_resource.activemqProvision","null_resource.dbProvision"]


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
        "sudo systemctl stop firewalld",
        "sudo systemctl disable firewalld",
        "sudo yum install -y git java-1.8.0-openjdk tomcat",
        "echo DBip=${azurerm_network_interface.dbInt.private_ip_address} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo DBport=${var.psqlPort} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo DBpass=${var.psqlPass} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo DBuser=${var.psqlUser} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo ActiveMQ_URL=${azurerm_network_interface.activeInt.private_ip_address} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo ActiveMQ_Port=${var.activeMqPort} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo ActiveMQ_User=admin| sudo tee -a /etc/tomcat/tomcat.conf",
        "echo ActiveMQ_Password=${var.activeMqRootPass} | sudo tee -a /etc/tomcat/tomcat.conf",
        "echo verifyURL=${azurerm_network_interface.validateInt.private_ip_address} | sudo sudo tee -a /etc/tomcat/tomcat.conf",
        "echo AWS_UPLOAD_SEC=${var.awsUploadSec} | sudo sudo tee -a /etc/tomcat/tomcat.conf",
        "echo AWS_UPLOAD_KEY=${var.awsUploadKey} | sudo sudo tee -a  /etc/tomcat/tomcat.conf",
        "echo AWS_UPLOAD_BUCKET=${var.awsUploadBucket} | sudo sudo tee -a /etc/tomcat/tomcat.conf",
        "echo S3SourceBucket=${var.awsUploadBucket} | sudo sudo tee -a /etc/tomcat/tcomcat.conf",
        "echo S3DestBucket=${var.awsUploadVerBucket} | sudo sudo tee -a /etc/tomcat/tomcat.conf",
        "echo S3AccessKey=${var.awsUploadKey} | sudo sudo tee -a /etc/tomcat/tomcat.conf",
        "echo S3SecretKey=${var.awsUploadSec} | sudo sudo tee -a /etc/tomcat/tomcat.conf",
        "echo release=${var.release} | sudo sudo tee -a /etc/profile.d/dmc.sh",
	      "echo solrDbDns=http://${azurerm_network_interface.solrInt.private_ip_address}:${var.solrPort}/solr | sudo tee -a /etc/tomcat/tomcat.conf",
	      "echo SOLR_BASE_URL=http://${azurerm_network_interface.solrInt.private_ip_address}:${var.solrPort}/solr | sudo tee -a /etc/tomcat/tomcat.conf",
        "chmod +x /tmp/script.sh",
        "cd /tmp",
        "bash -x script.sh 2>&1 | tee out.log"
       ]

       connection {
           host = "${azurerm_public_ip.restPubIp.ip_address}"
           user = "${var.dmcUser}"
           private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
       }
  }
}
