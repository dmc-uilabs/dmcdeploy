/*

resource "azurerm_virtual_machine" "test" {
    name = "acctvm"
    location = "West US"
    resource_group_name = "${azurerm_resource_group.tfResourceGroup.name}"
    network_interface_ids = ["${azurerm_network_interface.tfNI.id}"]
    vm_size = "Standard_A0"

    storage_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "14.04.2-LTS"
        version = "latest"
    }

    storage_os_disk {
        name = "myosdisk1"
        vhd_uri = "${azurerm_storage_account.tfStor1.primary_blob_endpoint}${azurerm_storage_container.tfStor1Cont.name}/myosdisk1.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "hostname"
        admin_username = "testadmin"
        admin_password = "Password1234!"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    tags {
        environment = "staging"
    }
}
*/
