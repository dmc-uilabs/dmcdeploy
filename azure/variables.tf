variable "subscriptionId" {}
variable "clientId" {}
variable "clientSecret" {}
variable "tenantId" {}



variable "azureRegion" {}


variable "serverURL" {}


variable "stackPrefix" {}
variable "vmSize" {}
variable "staticAssets" {}




variable "dmcUser" {}

variable "dmcPass" {
  default = "Password1234!"
}

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



variable "mode" {}
#available versions 0.1.1
variable "release" {}



variable "awsUploadSec" {}
variable "awsUploadKey" {}
variable "awsUploadBucket" {}

variable "awsRestKey" {}
variable "awsRestSecret" {}


variable "awsUploadVerBucket" {}

variable "solrPort" {}

variable "subnetRange" {}



variable defaultOS {
  type = "map"
  default = {
    osvendor = "RedHat"
    osname = "RHEL"
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


variable centOS {
  type = "map"
  default = {
    osvendor = "OpenLogic"
    osname = "CentOS"
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


