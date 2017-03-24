resource "azurerm_public_ip" "appGWPubIp" {
    name = "${var.stackPrefix}appgwpubip"
    location = "${var.azureRegion}"
    resource_group_name = "${azurerm_resource_group.resource.name}"
    public_ip_address_allocation = "dynamic"
}


resource "azurerm_template_deployment" "appgw" {
  depends_on = ["azurerm_public_ip.frontPubIp","azurerm_public_ip.appGWPubIp"]
  name  = "${var.appgwname}"
  resource_group_name =  "${azurerm_resource_group.resource.name}"
  deployment_mode = "Incremental"
  parameters = {
    addressPrefix = "${var.appgwprivnet}"
    subnetPrefix = "${var.appgwprivsubnet}"
    skuName = "${var.appgwclass}"
    backendIpAddress1 = "${azurerm_public_ip.frontPubIp.ip_address}"
    certData = "${file("/home/chancock/Documents/dmccertbase64")}"
    certPassword = "Eingai4b"
    gwPublicIpName = "${azurerm_public_ip.appGWPubIp.name}"
  }
  template_body = "${file("azuretemplates/template.json")}"
}
