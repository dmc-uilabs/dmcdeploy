resource "azurerm_public_ip" "solrPubIp" {
    name = "${var.stackPrefix}solrpubip"
    location = "${var.azureRegion}"
    resource_group_name = "${azurerm_resource_group.resource.name}"
    public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "solrInt" {
    name = "${var.stackPrefix}solrni"
    location = "${var.azureRegion}"
    resource_group_name = "${azurerm_resource_group.resource.name}"

    ip_configuration {
        name = "${var.stackPrefix}SolrIntNetIntIp"
        subnet_id = "${azurerm_subnet.resource.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = "${azurerm_public_ip.solrPubIp.id}"
    }
}

resource "azurerm_virtual_machine" "solrvm" {
    name = "solrVm"
    location = "${var.azureRegion}"
    resource_group_name = "${azurerm_resource_group.resource.name}"
    network_interface_ids = ["${azurerm_network_interface.solrInt.id}"]
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
        name = "solrOsDisk"
        vhd_uri = "${azurerm_storage_account.resource.primary_blob_endpoint}${azurerm_storage_container.resource.name}/solrOsDisk.vhd"
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
