resource "null_resource" "frontProvision2" {
  depends_on = ["null_resource.frontProvision"]


  provisioner "remote-exec" {
         inline = [
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
