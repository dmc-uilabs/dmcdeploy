resource "null_resource" "frontProvision" {
  depends_on = ["azurerm_virtual_machine.front","null_resource.dbProvision","null_resource.restProvision"]


provisioner "file" {
      source = "scripts/deployMe_front_azure.sh"
      destination = "/tmp/script.sh"

      connection {
          host = "${azurerm_public_ip.frontPubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }



  provisioner "file" {
        source = "scripts/apache24.conf"
        destination = "/tmp/apache24.conf"

        connection {
            host = "${azurerm_public_ip.frontPubIp.ip_address}"
            user = "${var.dmcUser}"
            private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
        }
    }


provisioner "remote-exec" {
       inline = [
        "sudo systemctl stop firewalld",
        "sudo systemctl disable firewalld",
        "sudo yum -y install wget git java-1.8.0-openjdk httpd",
	      "echo export AWS_UPLOAD_SEC=${var.awsUploadSec} | sudo tee /etc/profile.d/dmc.sh",
        "echo export AWS_UPLOAD_KEY=${var.awsUploadKey} | sudo tee -a /etc/profile.d/dmc.sh ",
        "echo export AWS_UPLOAD_BUCKET=${var.awsUploadBucket} | sudo tee -a /etc/profile.d/dmc.sh",
        "echo export dmcreleasever=${var.dmcreleasever} | sudo tee -a /etc/profile.d/dmc.sh",
        "echo export solrDbDns= | sudo tee -a /etc/profile.d/dmc.sh",
        "echo export use_swagger=0  | sudo tee -a /etc/profile.d/dmc.sh",
        "echo export dmcURL=${var.dmcURL} | sudo tee -a /etc/profile.d/dmc.sh",
        "echo export dmcenvmode=${var.dmcenvmode} | sudo tee -a /etc/profile.d/dmc.sh",
        "echo export dmcreleasever=${var.dmcreleasever} | sudo sudo tee -a /etc/profile.d/dmc.sh",
        "echo export restIp=${azurerm_network_interface.restInt.private_ip_address} | sudo tee -a /etc/profile.d/dmc.sh",
        "source /etc/profile.d/dmc.sh",
        "chmod +x /tmp/script.sh",
        "cd /tmp",
        "bash -x script.sh 2>&1 | tee out.log"
       ]

       connection {
           host = "${azurerm_public_ip.frontPubIp.ip_address}"
           user = "${var.dmcUser}"
           private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
       }
  }
}
