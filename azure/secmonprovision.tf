resource "null_resource" "secmonProvision" {
  depends_on = ["azurerm_virtual_machine.secmon"]


  provisioner "file" {
      source = "configs/secmon/logstash/02-beats-input.conf"
      destination = "/tmp/02-beats-input.conf"

      connection {
          host = "${azurerm_public_ip.secmonPubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }

  provisioner "file" {
      source = "configs/secmon/logstash/10-syslog-filter.conf"
      destination = "/tmp/10-syslog-filter.conf"

      connection {
          host = "${azurerm_public_ip.secmonPubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }

  provisioner "file" {
        source = "configs/secmon/logstash/30-elasticsearch-output.conf"
        destination = "/tmp/30-elasticsearch-output.conf"

        connection {
            host = "${azurerm_public_ip.secmonPubIp.ip_address}"
            user = "${var.dmcUser}"
            private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
        }
  }

  provisioner "file" {
        source = "configs/secmon/kibana/kibana.conf"
        destination = "/tmp/kibana.conf"

        connection {
            host = "${azurerm_public_ip.secmonPubIp.ip_address}"
            user = "${var.dmcUser}"
            private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
        }
  }

   provisioner "file" {
      source = "scripts/deployMe_oscheck.sh"
      destination = "/tmp/oscheck.sh"

      connection {
          host = "${azurerm_public_ip.secmonPubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }

 provisioner "file" {
      source = "scripts/deployMe_nessus.sh"
      destination = "/tmp/deployMe_nessus.sh"

      connection {
          host = "${azurerm_public_ip.secmonPubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }
   provisioner "file" {
      source = "scripts/deployMe_secmon.sh"
      destination = "/tmp/deployMe_secmon.sh"

      connection {
          host = "${azurerm_public_ip.secmonPubIp.ip_address}"
          user = "${var.dmcUser}"
          private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
      }
  }


    provisioner "remote-exec" {
    inline = ["bash -x /tmp/oscheck.sh 2>&1 | tee /tmp/out2.log"]
    connection {
       host = "${azurerm_public_ip.secmonPubIp.ip_address}"
       user = "${var.dmcUser}"
       private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
    }
 }

 provisioner "remote-exec" {
    inline = ["bash -x /tmp/deployMe_secmon.sh 2>&1 | tee /tmp/out2.log"]
    connection {
       host = "${azurerm_public_ip.secmonPubIp.ip_address}"
       user = "${var.dmcUser}"
       private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
    }
 }
 provisioner "remote-exec" {
    inline = ["bash -x /tmp/deployMe_nessus.sh ${var.nessusapikey} ${azurerm_resource_group.resource.name} 2>&1 | tee /tmp/out3.log"]
    connection {
       host = "${azurerm_public_ip.secmonPubIp.ip_address}"
       user = "${var.dmcUser}"
       private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
    }
 }

}
