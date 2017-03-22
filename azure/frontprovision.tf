resource "null_resource" "frontProvision" {
  depends_on = ["azurerm_virtual_machine.front","null_resource.dbProvision","null_resource.restProvision"]


provisioner "file" {
      source = "scripts/deployMe_oscheck.sh"
      destination = "/tmp/os_script.sh"

      connection {
          host = "${azurerm_public_ip.frontPubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }



provisioner "file" {
      source = "scripts/deployMe_front_azure.sh"
      destination = "/tmp/script.sh"

      connection {
          host = "${azurerm_public_ip.frontPubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }



provisioner "remote-exec" {
       inline = [
        "sudo bash -x /tmp/os_script.sh 2>&1 | tee -a /tmp/out.log",
	"echo export AWS_UPLOAD_SEC=${var.awsUploadSec} | sudo tee /etc/profile.d/dmc.sh",
        "echo export AWS_UPLOAD_KEY=${var.awsUploadKey} | sudo tee -a /etc/profile.d/dmc.sh ",
        "echo export AWS_UPLOAD_BUCKET=${var.awsUploadBucket} | sudo tee -a /etc/profile.d/dmc.sh",
        "echo export dmcreleasever=${var.dmcreleasever} | sudo tee -a /etc/profile.d/dmc.sh",
        "echo export dmcURL=${var.dmcURL} | sudo tee -a /etc/profile.d/dmc.sh",
        "echo export dmcenvmode=${var.dmcenvmode} | sudo tee -a /etc/profile.d/dmc.sh",
        "echo export dmcreleasever=${var.dmcreleasever} | sudo tee -a /etc/profile.d/dmc.sh",
        "echo export restIp=${azurerm_network_interface.restInt.private_ip_address} | sudo tee -a /etc/profile.d/dmc.sh",
        "echo export dmcfrontdistver=${var.dmcfrontdistver} | sudo tee -a /etc/profile.d/dmc.sh",
        "source /etc/profile.d/dmc.sh",
        "chmod +x /tmp/script.sh",
        "cd /tmp",
        "sudo bash -x /tmp/script.sh 2>&1 | tee -a /tmp/out.log"
       ]

       connection {
           host = "${azurerm_public_ip.frontPubIp.ip_address}"
           user = "${var.dmcUser}"
           private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
       }
  }
}
