resource "azurerm_public_ip" "frontPubIp" {
    name = "${var.stackPrefix}frontpubip"
    location = "${var.azureRegion}"
    resource_group_name = "${azurerm_resource_group.resource.name}"
    public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "frontInt" {
    name = "${var.stackPrefix}frontni"
    location = "${var.azureRegion}"
    resource_group_name = "${azurerm_resource_group.resource.name}"

    ip_configuration {
        name = "${var.stackPrefix}FrontIntNetIntIp"
        subnet_id = "${azurerm_subnet.resource.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = "${azurerm_public_ip.frontPubIp.id}"
    }
}

resource "azurerm_virtual_machine" "front" {
    name = "frontVm"
    location = "${var.azureRegion}"
    resource_group_name = "${azurerm_resource_group.resource.name}"
    network_interface_ids = ["${azurerm_network_interface.frontInt.id}"]
    vm_size = "${var.vmSize}"
    delete_data_disks_on_termination = "true"
    delete_os_disk_on_termination = "true"

    storage_image_reference {
        publisher = "${var.redHat["osvendor"]}"
        offer = "${var.redHat["osname"]}"
        sku = "${var.redHat["osrelease"]}"
        version = "${var.redHat["osversion"]}"
    }

    storage_os_disk {
        name = "frontOsDisk"
        vhd_uri = "${azurerm_storage_account.resource.primary_blob_endpoint}${azurerm_storage_container.resource.name}/frontOsDisk.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "hostname"
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
