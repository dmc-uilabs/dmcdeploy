variable "subscriptionId" {}
variable "clientId" {}
variable "clientSecret" {}
variable "tenantId" {}


variable "azureRegion" {}
variable "vmSize" {}


#variable "serverURL" {}
variable "dmcURL" {}
variable "stackPrefix" {}
variable "dmcenvmode" {}
variable "dmcreleasever" {}
variable "dmcfrontdistver" {}



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


variable "awsUploadSec" {}
variable "awsUploadKey" {}
variable "awsUploadBucket" {}
variable "awsUploadVerBucket" {}

variable "awsRestKey" {}
variable "awsRestSecret" {}


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
variable "register_dns" {}

variable "secmon_status" {}
variable "docent_status" {}
variable "nessus_status" {}
variable "nessusapikey" {}


variable defaultOS {
  type = "map"
  default = {
    osvendor = "OpenLogic"
    osname = "CentOS"
    osrelease = "7.2"
    osversion = "latest"
  }
}

variable centOs {
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

variable "netmaps" {
  type = "map"
  default = {
    web1 = "10.0.1.0/24"
    web2 = "10.0.2.0/24"
    web3 = "10.0.3.0/24"
    web4 = "10.0.4.0/24"
    web5 = "10.0.5.0/24"
    web6 = "10.0.6.0/24"
    web7 = "10.0.7.0/24"
    web8= "10.0.8.0/24"
    web8= "10.0.8.0/24"
    portal = "10.0.9.0/24"
  }
}
