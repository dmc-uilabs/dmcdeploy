resource "null_resource" "nessusProvision" {
    count = "${var.nessus_status}"
    depends_on = ["azurerm_virtual_machine.front","null_resource.activemqProvision","null_resource.dbProvision"]


    provisioner "file" {
        source = "scripts/deployMe_nessus.sh"
        destination = "/tmp/nessus_script.sh"

        connection {
            host = "${azurerm_public_ip.restPubIp.ip_address}"
            user = "${var.dmcUser}"
            private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
        }
    }
    provisioner "file" {
        source = "scripts/deployMe_nessus.sh"
        destination = "/tmp/nessus_script.sh"

        connection {
            host = "${azurerm_public_ip.dbPubIp.ip_address}"
            user = "${var.dmcUser}"
            private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
        }
    }
    provisioner "file" {
        source = "scripts/deployMe_nessus.sh"
        destination = "/tmp/nessus_script.sh"

        connection {
            host = "${azurerm_public_ip.frontPubIp.ip_address}"
            user = "${var.dmcUser}"
            private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
        }
    }
    provisioner "file" {
        source = "scripts/deployMe_nessus.sh"
        destination = "/tmp/nessus_script.sh"

        connection {
            host = "${azurerm_public_ip.activePubIp.ip_address}"
            user = "${var.dmcUser}"
            private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
        }
    }
    provisioner "file" {
        source = "scripts/deployMe_nessus.sh"
        destination = "/tmp/nessus_script.sh"

        connection {
            host = "${azurerm_public_ip.solrPubIp.ip_address}"
            user = "${var.dmcUser}"
            private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
        }
    }
    provisioner "file" {
        source = "scripts/deployMe_nessus.sh"
        destination = "/tmp/nessus_script.sh"

        connection {
            host = "${azurerm_public_ip.validatePubIp.ip_address}"
            user = "${var.dmcUser}"
            private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
        }
    }

   provisioner "remote-exec" {
     inline = ["bash -x /tmp/nessus_script.sh ${var.nessusapikey} ${azurerm_resource_group.resource.name}  2>&1 | sudo tee -a /tmp/out.log"]
     connection {
       host = "${azurerm_public_ip.dbPubIp.ip_address}"
       user = "${var.dmcUser}"
       private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
     }
   }
   provisioner "remote-exec" {
     inline = ["bash -x /tmp/nessus_script.sh ${var.nessusapikey} ${azurerm_resource_group.resource.name}  2>&1 | sudo tee -a /tmp/out.log"]
     connection {
       host = "${azurerm_public_ip.frontPubIp.ip_address}"
       user = "${var.dmcUser}"
       private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
     }
   }
   provisioner "remote-exec" {
     inline = ["bash -x /tmp/nessus_script.sh ${var.nessusapikey} ${azurerm_resource_group.resource.name}  2>&1 | sudo tee -a /tmp/out.log"]
     connection {
       host = "${azurerm_public_ip.activePubIp.ip_address}"
       user = "${var.dmcUser}"
       private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
     }
   }
   provisioner "remote-exec" {
     inline = ["bash -x /tmp/nessus_script.sh ${var.nessusapikey} ${azurerm_resource_group.resource.name}  2>&1 | sudo tee -a /tmp/out.log"]
     connection {
       host = "${azurerm_public_ip.solrPubIp.ip_address}"
       user = "${var.dmcUser}"
       private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
     }
   }
   provisioner "remote-exec" {
     inline = ["bash -x /tmp/nessus_script.sh ${var.nessusapikey} ${azurerm_resource_group.resource.name}  2>&1 | sudo tee -a /tmp/out.log"]
     connection {
       host = "${azurerm_public_ip.validatePubIp.ip_address}"
       user = "${var.dmcUser}"
       private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
     }
   }
   provisioner "remote-exec" {
     inline = ["bash -x /tmp/nessus_script.sh ${var.nessusapikey} ${azurerm_resource_group.resource.name}  2>&1 | sudo tee -a /tmp/out.log"]
     connection {
       host = "${azurerm_public_ip.restPubIp.ip_address}"
       user = "${var.dmcUser}"
       private_key  = "${file("${var.sshKeyPath}/${var.sshKeyFilePri}")}"
     }
   }
}

