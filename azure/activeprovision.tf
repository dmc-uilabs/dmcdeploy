resource "null_resource" "activemqProvision" {
   depends_on = ["azurerm_virtual_machine.active"]

provisioner "file" {
      source = "scripts/deployMe_oscheck.sh"
      destination = "/tmp/os_script.sh"

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

  provisioner "remote-exec" {
         inline = [
          "chmod +x /tmp/*.sh",
          "bash -x /tmp/os_script.sh 2>&1 | tee out.log",
          "axel -n 10 https://archive.apache.org/dist/activemq/5.14.4/apache-activemq-5.14.4-bin.tar.gz",
          "tar zxvf apache-activemq-5.14.4-bin.tar.gz",
          "sudo mv apache-activemq-5.14.4 /opt",
          "sudo ln -sf /opt/apache-activemq-5.14.4/ /opt/activemq",
          "echo export activeMqRootPass=${var.activeMqRootPass} | sudo tee -a /etc/profile.d/dmc.sh",
          "echo export activeMqUserPass=${var.activeMqUserPass} | sudo tee -a /etc/profile.d/dmc.sh",
          "bash -x /tmp/script.sh 2>&1 | tee -a out.log"

         ]

         connection {
             host = "${azurerm_public_ip.activePubIp.ip_address}"
             user = "${var.dmcUser}"
             private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
         }
  }

}
