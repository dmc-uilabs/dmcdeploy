resource "null_resource" "dbProvision" {
  depends_on = ["azurerm_virtual_machine.db"]

provisioner "file" {
      source = "scripts/deployMe_oscheck.sh"
      destination = "/tmp/os_script.sh"

      connection {
          host = "${azurerm_public_ip.dbPubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }


provisioner "file" {
    source = "scripts/deployMe_db_azure.sh"
    destination = "/tmp/script.sh"

    connection {
        host = "${azurerm_public_ip.dbPubIp.ip_address}"
        user = "${var.dmcUser}"
        private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
    }
}

provisioner "remote-exec" {
       inline = [
        "chmod +x /tmp/*.sh",
        "bash -x /tmp/os_script.sh 2>&1 | tee /tmp/out.log",
        "sudo yum install -y http://ftp.postgresql.org/pub/repos/yum/9.4/redhat/rhel-6.7-x86_64/pgdg-redhat94-9.4-3.noarch.rpm",
        "sudo yum install -y postgresql94-server postgresql94-contrib",
        "sudo rm -rf /var/lib/pgsql/9.4/*",
        "sudo /usr/pgsql-9.4/bin/postgresql94-setup initdb",
        "echo export PSQLUSER=${var.psqlUser} | sudo tee  /etc/profile.d/dmc.sh",
        "echo export PSQLPASS=${var.psqlPass} | sudo tee -a /etc/profile.d/dmc.sh",
        "echo export DB=${var.psqlDb} | sudo tee -a /etc/profile.d/dmc.sh",
        "echo export dmcenvmode=${var.dmcenvmode} | sudo tee -a /etc/profile.d/dmc.sh",
        "bash -x /tmp/script.sh 2>&1 | tee -a /tmp/out.log"
       ]

       connection {
           host = "${azurerm_public_ip.dbPubIp.ip_address}"
           user = "${var.dmcUser}"
           private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
       }
}




}
