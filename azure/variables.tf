variable "subscriptionId" {}
variable "clientId" {}
variable "clientSecret" {}
variable "tenantId" {}


variable "azureRegion" {}
variable "vmSize" {}


#variable "serverURL" {}
variable "dmcURL" {}
variable "stackPrefix" {}



variable "dmcUser" {}
variable "dmcPass" {default = "Password1234!"}
variable "sshKeyPath" {}
variable "sshKeyFilePri" {}
variable "sshKeyFilePub" {}



variable "psqlUser" {}
variable "psqlPass" {}
variable "psqlDb" {}
variable "psqlPort" {}


variable "activeMqRootPass" {}
variable "activeMqUserPass" {}
variable "activeMqPort" {}



variable "dmcvenvmode" {}
variable "dmcreleasever" {}



variable "awsUploadSec" {}
variable "awsUploadKey" {}
variable "awsUploadBucket" {}

variable "awsRestKey" {}
variable "awsRestSecret" {}


variable "awsUploadVerBucket" {}

variable "solrPort" {}

variable "subnetRange" {}


variable "networkRange" {
  default = "10.0.0.0/16"
}


variable "appgwname" {}
variable "appgwprivnet" {}
variable "appgwprivsubnet" {}
variable "appgwclass" {}
variable "appgwsize" { default = 0}
variable "certbase64" {}
variable "certpass" {}


variable "cloudflare_domain" {}
variable "cloudflare_email" {}
variable "cloudflare_token" {}

variable "secmon_status" {}
variable "docent_status" {}


variable defaultOS {
  type = "map"
  default = {
    osvendor = "OpenLogic"
    osname = "CentOS"
    osrelease = "7.2"
    osversion = "latest"
  }
}


variable redHat {
  type = "map"
  default = {
    osvendor = "RedHat"
    osname = "RHEL"
    osrelease = "7.2"
    osversion = "latest"
  }
}


variable ubuntu {
  type = "map"
  default = {
    osvendor = "Canonical"
    osname = "UbuntuServer"
    osrelease = "16.04.0-LTS"
    osversion = "latest"
  }
}
