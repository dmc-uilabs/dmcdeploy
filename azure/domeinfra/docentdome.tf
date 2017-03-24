resource "azurerm_public_ip" "docentdomePubIp" {
    count = "${var.docent_status}"
    name = "${var.stackPrefix}docentdomepubip"
    location = "${var.azureRegion}"
    resource_group_name = "${var.rgname}"
    public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "docentdomeInt" {
    count = "${var.docent_status}"
    name = "${var.stackPrefix}docentdomeni"
    location = "${var.azureRegion}"
    resource_group_name = "${var.rgname}"

    ip_configuration {
        name = "${var.stackPrefix}docentdomeIntNetIntIp"
        subnet_id = "/subscriptions/${var.subscriptionId}/resourceGroups/${var.rgname}/providers/Microsoft.Network/virtualNetworks/${var.appgwname}vn/subnets/${var.appgwname}sn"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = "${azurerm_public_ip.docentdomePubIp.id}"
    }
}

resource "azurerm_virtual_machine" "docentdome" {
    count = "${var.docent_status}"
    name = "docentdomeVm"
    location = "${var.azureRegion}"
    resource_group_name = "${var.rgname}"
    network_interface_ids = ["${azurerm_network_interface.docentdomeInt.id}"]
    vm_size = "${var.vmSize}"
    delete_data_disks_on_termination = "true"
    delete_os_disk_on_termination = "true"

    storage_image_reference {
        publisher = "${var.ubuntu["osvendor"]}"
        offer = "${var.ubuntu["osname"]}"
        sku = "${var.ubuntu["osrelease"]}"
        version = "${var.ubuntu["osversion"]}"
    }


    storage_os_disk {
        name = "docentdomeOsDisk"
        vhd_uri = "https://${var.appgwname}stacf.blob.core.windows.net/${var.appgwname}stcon/docentdomeOsDisk.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "docentdome.${var.appgwname}"
        admin_username = "${var.dmcUser}"
        admin_password = "${var.dmcPass}"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
          path = "/home/${var.dmcUser}/.ssh/authorized_keys"
          key_data ="${file("${var.sshKeyPath}/${var.sshKeyFilePub}")}"
        }
    }

}
