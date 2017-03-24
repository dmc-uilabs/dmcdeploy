terraform {
  required_version = "~> 0.9.1"
}


resource "azurerm_resource_group" "resource" {
    name = "${var.stackPrefix}v${var.dmcreleasever}_rg"
    location = "${var.azureRegion}"
}

resource "azurerm_virtual_network" "resource" {
    name = "${var.stackPrefix}vn"
    address_space = ["${lookup(var.netmaps, var.stackPrefix)}"]
    location = "${var.azureRegion}"
    resource_group_name = "${azurerm_resource_group.resource.name}"
}

resource "azurerm_storage_account" "resource" {
    name = "${var.stackPrefix}stacc"
    resource_group_name = "${azurerm_resource_group.resource.name}"
    location = "${var.azureRegion}"
    account_type = "Standard_LRS"
    lifecycle {
        create_before_destroy = true
    }
}

resource "azurerm_storage_container" "resource" {
    name = "${var.stackPrefix}stcon"
    resource_group_name = "${azurerm_resource_group.resource.name}"
    storage_account_name = "${azurerm_storage_account.resource.name}"
    container_access_type = "private"
    lifecycle {
        create_before_destroy = true
    }
}

resource "azurerm_subnet" "resource" {
    name = "${var.stackPrefix}sn"
    resource_group_name = "${azurerm_resource_group.resource.name}"
    virtual_network_name = "${azurerm_virtual_network.resource.name}"
    address_prefix = "${lookup(var.netmaps, var.stackPrefix)}"
}
