resource "azurerm_public_ip" "validatePubIp" {
    name = "${var.stackPrefix}validatepubip"
    location = "${var.azureRegion}"
    resource_group_name = "${azurerm_resource_group.resource.name}"
    public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "validateInt" {
    name = "${var.stackPrefix}validateni"
    location = "${var.azureRegion}"
    resource_group_name = "${azurerm_resource_group.resource.name}"

    ip_configuration {
        name = "${var.stackPrefix}ValidateIntNetIntIp"
        subnet_id = "${azurerm_subnet.resource.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = "${azurerm_public_ip.validatePubIp.id}"
    }
}

resource "azurerm_virtual_machine" "validate" {
    name = "validateVm"
    location = "${var.azureRegion}"
    resource_group_name = "${azurerm_resource_group.resource.name}"
    network_interface_ids = ["${azurerm_network_interface.validateInt.id}"]
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
        name = "validateOsDisk"
        vhd_uri = "${azurerm_storage_account.resource.primary_blob_endpoint}${azurerm_storage_container.resource.name}/validateOsDisk.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "validate..${var.appgwname}"
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
