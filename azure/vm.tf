resource "azurerm_resource_group" "tfResourceGroup" {
    name = "acctestrg"
    location = "West US"
}



resource "azurerm_public_ip" "test" {
    name = "acceptanceTestPublicIp1"
    location = "West US"
    resource_group_name = "${azurerm_resource_group.tfResourceGroup.name}"
    public_ip_address_allocation = "static"

    tags {
        environment = "staging"
    }
}


resource "azurerm_virtual_network" "tfVNet" {
    name = "acctvn"
    address_space = ["10.0.0.0/16"]
    location = "West US"
    resource_group_name = "${azurerm_resource_group.tfResourceGroup.name}"
}

resource "azurerm_subnet" "tfSubnet" {
    name = "acctsub"
    resource_group_name = "${azurerm_resource_group.tfResourceGroup.name}"
    virtual_network_name = "${azurerm_virtual_network.tfVNet.name}"
    address_prefix = "10.0.2.0/24"
}

resource "azurerm_network_interface" "tfNI" {
    name = "acctni"
    location = "West US"
    resource_group_name = "${azurerm_resource_group.tfResourceGroup.name}"

    ip_configuration {
        name = "testconfiguration1"
        subnet_id = "${azurerm_subnet.tfSubnet.id}"
        private_ip_address_allocation = "dynamic"
    }
}

resource "azurerm_storage_account" "tfStor1" {
    name = "tfstory"
    resource_group_name = "${azurerm_resource_group.tfResourceGroup.name}"
    location = "westus"
    account_type = "Standard_LRS"

    tags {
        environment = "staging"
    }
}

resource "azurerm_storage_container" "tfStor1Cont" {
    name = "vhds"
    resource_group_name = "${azurerm_resource_group.tfResourceGroup.name}"
    storage_account_name = "${azurerm_storage_account.tfStor1.name}"
    container_access_type = "private"
}
