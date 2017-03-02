resource "null_resource" "frontProvision2" {
  depends_on = ["null_resource.frontProvision"]


provisioner "file" {
      source = "${var.staticAssets}"
      destination = "/tmp"

      connection {
          host = "${azurerm_public_ip.frontPubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }

provisioner "file" {
      source = "configs/secmon/filebeat.zip"
      destination = "/tmp/filebeat.zip"

      connection {
          host = "${azurerm_public_ip.frontPubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }
provisioner "file" {
      source = "scripts/deployMe_nessus.sh"
      destination = "/tmp/deployMe_nessus.sh"

      connection {
          host = "${azurerm_public_ip.frontPubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }

provisioner "remote-exec" {
  inline = ["bash -x /tmp/deployMe_nessus.sh ${var.nessusapikey} 2>&1 | tee /tmp/out3.log"]
  connection {
     host = "${azurerm_public_ip.frontPubIp.ip_address}"
     user = "${var.dmcUser}"
     private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
  }
}


  provisioner "remote-exec" {
         inline = [
          "/tmp/dmcstatic",
          "ls /tmp/dmcstatic",
          "cd /tmp",
          "unzip /tmp/filebeat.zip",
          "cd /tmp/filebeat",
          "sudo yum -y install https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.2.2-x86_64.rpm",
          "sudo cp * /etc/filebeat",
          "sudo cp /tmp/apache24.conf /etc/httpd/conf.d/apache24.conf",
          "sudo  mv sp-cert.pem /opt/shibboleth-sp/etc/shibboleth/sp-cert.pem",
          "sudo  chown root:root /opt/shibboleth-sp/etc/shibboleth/sp-cert.pem",
          "sudo  chmod 400 /opt/shibboleth-sp/etc/shibboleth/sp-cert.pem",
          "sudo  mv sp-key.pem /opt/shibboleth-sp/etc/shibboleth/sp-key.pem",
          "sudo  chown root:root /opt/shibboleth-sp/etc/shibboleth/sp-key.pem",
          "sudo  chmod 400 /opt/shibboleth-sp/etc/shibboleth/sp-key.pem",
          "sudo  mv inc-md-cert.pem /opt/shibboleth-sp/etc/shibboleth/inc-md-cert.pem",
          "sudo  chown root:root /opt/shibboleth-sp/etc/shibboleth/inc-md-cert.pem",
          "sudo  chmod 400 /opt/shibboleth-sp/etc/shibboleth/inc-md-cert.pem",
          "sudo sed -i -e 's/enforcing/disabled/g' /etc/selinux/config",
          "sudo chkconfig httpd on",
          "sudo reboot now"
         ]



         connection {
             host = "${azurerm_public_ip.frontPubIp.ip_address}"
             user = "${var.dmcUser}"
             private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
         }
    }



}
