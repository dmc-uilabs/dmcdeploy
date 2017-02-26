resource "azurerm_template_deployment" "appgw" {
  depends_on = ["null_resource.frontProvision2"]
  nams  = "{var.appgwname}"
  resource_group_name =  ${azurerm_resource_group.name}
  deployment = "Incremental"
  parameters = {
    addressPrefix = "${var.appgwprivnet}"
    subnetPrefix = "${var.appgwprivsubnet}"
    skuName = "${var.appgwclass}"
    capacity = "${var.appgwsize}"
    backendIpAddress1 = "${azurerm_public_ip.frontPubIp.ip}"
    certData = ""
    certPassword = ""
  }
  template_body = file("/home/chancock/Downloads/azuressl/template.json")
  
}
