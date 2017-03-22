resource "null_resource" "validateProvision" {
  depends_on = ["azurerm_virtual_machine.validate"]

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
        source = "scripts/deployMe_validate_azure.sh"
        destination = "/tmp/script.sh"

        connection {
            host = "${azurerm_public_ip.validatePubIp.ip_address}"
            user = "${var.dmcUser}"
            private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
        }
    }


provisioner "remote-exec" {
       inline = [
        "sudo bash -x /tmp/os_check.sh 2>&1 | tee -a /tmp/out.log",
        "sudo rm -rf /usr/local/nvm",
        "sudo rm -rf /opt/validation",
        "echo export NVM_DIR=/usr/local/nvm | sudo tee /etc/profile.d/dmc.sh",
        "echo '[ -s $NVM_DIR/nvm.sh ] && . $NVM_DIR/nvm.sh' | sudo tee -a  /etc/profile.d/dmc.sh",
      	"source /etc/profile.d/dmc.sh",
      	"curl https://raw.githubusercontent.com/creationix/nvm/v0.30.1/install.sh | sudo NVM_DIR=/usr/local/nvm bash",
      	"sudo -i nvm install stable",
      	"sudo -i nvm alias default stable",
      	"sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm",
      	"sudo yum -y install clamav clamav-update",
      	"sudo sed '5,/Example/s/Example/#Example/' /etc/freshclam.conf",
      	"sudo -i npm install -g pm2",
      	"sudo chmod 777 /opt",
        "chmod +x /tmp/script.sh",
        "cd /tmp",
        "bash -x script.sh 2>&1 | tee -a /tmp/out.log",
       ]


       connection {
           host = "${azurerm_public_ip.validatePubIp.ip_address}"
           user = "${var.dmcUser}"
           private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
       }



   }
}
