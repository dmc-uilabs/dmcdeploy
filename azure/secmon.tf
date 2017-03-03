resource "azurerm_public_ip" "secmonPubIp" {
    name = "${var.stackPrefix}secmonpubip"
    location = "${var.azureRegion}"
    resource_group_name = "${azurerm_resource_group.resource.name}"
    public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "secmonInt" {
    name = "${var.stackPrefix}secmonni"
    location = "${var.azureRegion}"
    resource_group_name = "${azurerm_resource_group.resource.name}"

    ip_configuration {
        name = "${var.stackPrefix}ActiveIntNetIntIp"
        subnet_id = "${azurerm_subnet.resource.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = "${azurerm_public_ip.secmonPubIp.id}"
    }
}

resource "azurerm_virtual_machine" "secmon" {
    name = "secmonVm"
    location = "${var.azureRegion}"
    resource_group_name = "${azurerm_resource_group.resource.name}"
    network_interface_ids = ["${azurerm_network_interface.secmonInt.id}"]
    vm_size = "${var.vmSize}"
    delete_data_disks_on_termination = "true"
    delete_os_disk_on_termination = "true"

    storage_image_reference {
        publisher = "${var.defaultOS["osvendor"]}"
        offer = "${var.defaultOS["osname"]}"
        sku = "${var.defaultOS["osrelease"]}"
        version = "${var.defaultOS["osversion"]}"
    }

    storage_os_disk {
        name = "secmonOsDisk"
        vhd_uri = "${azurerm_storage_account.resource.primary_blob_endpoint}${azurerm_storage_container.resource.name}/secmonOsDisk.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "secmon.${var.appgwname}"
        admin_username = "${var.dmcUser}"
        admin_password = "${var.dmcPass}"
    }

    os_profile_linux_config {
        disable_password_authentication = "true"
        ssh_keys {
          path = "/home/${var.dmcUser}/.ssh/authorized_keys"
          key_data ="${file("${var.sshKeyPath}/${var.sshKeyFilePub}")}"
        }
    }

}
