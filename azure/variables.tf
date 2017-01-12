variable "subscriptionId" {}
variable "clientId" {}
variable "clientSecret" {}
variable "tenantId" {}



variable "azureRegion" {
  default = "West US 2"
}





variable "stackPrefix" {
  default = "alex"
}
variable "vmSize" {
  default = "Standard_DS2_V2"
}



variable "dmcUser" {
  default = "dmcAdmin"
}
variable "dmcPass" {
  default = "Password1234!"
}

variable "sshKeyPath" {}
variable "sshKeyFilePri" {}
variable "sshKeyFilePub" {}





variable redHat {
  type = "map"
  default = {
    osvendor = "RedHat"
    osname = "RHEL"
    osrelease = "7.2"
    osversion = "latest"
  }
}

variable "networkRange" {
  default = "10.0.0.0/16"
}
