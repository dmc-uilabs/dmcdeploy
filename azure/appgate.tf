resource "azurerm_template_deployment" "appgw" {
  depends_on = ["null_resource.frontProvision2"]
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
  }
  template_body = "${file("/home/chancock/Downloads/azuressl/template.json")}"
  
}
