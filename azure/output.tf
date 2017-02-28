output "dbPubIp.ip" {
  value = "${azurerm_public_ip.dbPubIp.ip_address}"
}
output "dbSSH" {
  value = "cd ${var.sshKeyPath} && ssh -i '${var.sshKeyFilePri}' ${var.dmcUser}@${azurerm_public_ip.dbPubIp.ip_address}"
}

output "activePubIp.ip" {
  value = "${azurerm_public_ip.activePubIp.ip_address}"
}
output "activeSSH" {
  value = "cd ${var.sshKeyPath} && ssh -i '${var.sshKeyFilePri}' ${var.dmcUser}@${azurerm_public_ip.activePubIp.ip_address}"
}


output "restPubIp.ip" {
  value = "${azurerm_public_ip.restPubIp.ip_address}"
}
output "restSSH" {
  value = "cd ${var.sshKeyPath} && ssh -i '${var.sshKeyFilePri}' ${var.dmcUser}@${azurerm_public_ip.restPubIp.ip_address}"
}



output "domePubIp.ip" {
  value = "${azurerm_public_ip.domePubIp.ip_address}"
}
output "domeSSH" {
  value = "cd ${var.sshKeyPath} && ssh -i '${var.sshKeyFilePri}' ${var.dmcUser}@${azurerm_public_ip.domePubIp.ip_address}"
}



output "validatePubIp.ip" {
  value = "${azurerm_public_ip.validatePubIp.ip_address}"
}
output "validateSSH" {
  value = "cd ${var.sshKeyPath} && ssh -i '${var.sshKeyFilePri}' ${var.dmcUser}@${azurerm_public_ip.validatePubIp.ip_address}"
}



output "frontPubIp.ip" {
  value = "${azurerm_public_ip.frontPubIp.ip_address}"
}
output "frontSSH" {
  value = "cd ${var.sshKeyPath} && ssh -i '${var.sshKeyFilePri}' ${var.dmcUser}@${azurerm_public_ip.frontPubIp.ip_address}"
}



output "solrPubIp.ip" {
  value = "${azurerm_public_ip.solrPubIp.ip_address}"
}
output "solrSSH" {
  value = "cd ${var.sshKeyPath} && ssh -i '${var.sshKeyFilePri}' ${var.dmcUser}@${azurerm_public_ip.solrPubIp.ip_address}"
}

output "appGWPubIp.ip" {
  value = "${azurerm_public_ip.frontPubIp.ip_address}"
}
output "dmcWEB" {
  value = "Website IP is ${azurerm_public_ip.appGWPubIp.ip_address} and cloudflare resolves to ${var.serverURL}"
}
