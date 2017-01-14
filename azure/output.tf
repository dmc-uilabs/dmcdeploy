output "dbPubIp.ip" {
  value = "${azurerm_public_ip.dbPubIp.ip_address}"
}
output "dbSSH" {
  value = "cd ${var.sshKeyPath} && ssh -i '${var.sshKeyFilePri}' ${var.dmcUser}@${azurerm_public_ip.dbPubIp.ip_address}"
}



output "restPubIp.ip" {
  value = "${azurerm_public_ip.restPubIp.ip_address}"
}
output "restSSH" {
  value = "cd ${var.sshKeyPath} && ssh -i '${var.sshKeyFilePri}' ${var.dmcUser}@${azurerm_public_ip.restPubIp.ip_address}"
}



output "activePubIp.ip" {
  value = "${azurerm_public_ip.activePubIp.ip_address}"
}
output "activeSSH" {
  value = "cd ${var.sshKeyPath} && ssh -i '${var.sshKeyFilePri}' ${var.dmcUser}@${azurerm_public_ip.activePubIp.ip_address}"
}
