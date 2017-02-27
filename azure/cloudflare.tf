provider "cloudflare" {
    email = "${var.cloudflare_email}"
    token = "${var.cloudflare_token}"
}


resource "cloudflare_record" "main" {
    domain = "${var.cloudflare_domain}"
    name = "dev-web7"
    value = "${azurerm_public_ip.appGWPubIp.ip_address}"
    type = "A"
    ttl = 360
}

