resource "azurerm_public_ip" "docentdomePubIp" {
    count = "${var.docent_status}"
    name = "${var.stackPrefix}docentdomepubip"
    location = "${var.azureRegion}"
    resource_group_name = "${azurerm_resource_group.resource.name}"
    public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "docentdomeInt" {
    count = "${var.docent_status}"
    name = "${var.stackPrefix}docentdomeni"
    location = "${var.azureRegion}"
    resource_group_name = "${azurerm_resource_group.resource.name}"

    ip_configuration {
        name = "${var.stackPrefix}docentdomeIntNetIntIp"
        subnet_id = "${azurerm_subnet.resource.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = "${azurerm_public_ip.docentdomePubIp.id}"
    }
}

resource "azurerm_virtual_machine" "docentdome" {
    count = "${var.docent_status}"
    name = "docentdomeVm"
    location = "${var.azureRegion}"
    resource_group_name = "${azurerm_resource_group.resource.name}"
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
        vhd_uri = "${azurerm_storage_account.resource.primary_blob_endpoint}${azurerm_storage_container.resource.name}/docentdomeOsDisk.vhd"
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
