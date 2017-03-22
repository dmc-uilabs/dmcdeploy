provider "cloudflare" {
    email = "${var.cloudflare_email}"
    token = "${var.cloudflare_token}"
}


resource "cloudflare_record" "main" {
    count = "${var.register_dns}"
    domain = "${var.cloudflare_domain}"
    name = "${var.appgwname}"
    value = "${azurerm_public_ip.appGWPubIp.ip_address}"
    type = "A"
    ttl = 360
}

