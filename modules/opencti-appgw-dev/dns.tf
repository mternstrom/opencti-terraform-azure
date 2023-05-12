data "cloudflare_zones" "root_domain" {
  filter {
    name   = var.root_domain
    status = "active"
  }
}

resource "cloudflare_record" "acme_challenge_txt_record" {
  depends_on = [acme_certificate.appgw_cert]

  zone_id    = data.cloudflare_zones.root_domain.id
  name       = "_acme-challenge.${local.full_domain}"
  type       = "TXT"
  value      = "800fcMuCfvMvNQP_oweEdeLHwqjmVM9oED65Vv-Pnhs" #acme_certificate.appgw_cert.dns_challenge_records[0].value
  ttl        = 120
}

/*
resource "cloudflare_record" "a_record" {
  depends_on = [azurerm_public_ip.appgw]

  zone_id    = data.cloudflare_zones.root_domain.id
  name       = var.root_domain
  type       = "A"
  value      = "84.50.154.15"
  ttl        = 1
}

resource "cloudflare_record" "www_a_record" {
  depends_on = [azurerm_public_ip.appgw]
  zone_id    = data.cloudflare_zones.root_domain.id
  name       = "www.${local.full_domain}"
  type       = "A"
  value      = "84.50.154.15"
  ttl        = 1
}

resource "cloudflare_record" "opencti_dev_a_record" {
  depends_on = [azurerm_public_ip.appgw]
  zone_id    = data.cloudflare_zones.root_domain.id
  name       = local.full_domain
  type       = "A"
  value      = "84.50.154.15"
  ttl        = 1
}

resource "cloudflare_record" "elasticsearch_a_record" {
  zone_id = data.cloudflare_zones.root_domain.id
  name    = "elasticsearch.${local.full_domain}"
  type    = "A"
  value   = "10.16.35.163"
  ttl     = 1
}

resource "cloudflare_record" "kibana_a_record" {
  zone_id = data.cloudflare_zones.root_domain.id
  name    = "kibana.${local.full_domain}"
  type    = "A"
  value   = "10.16.35.213"
  ttl     = 1
}

resource "cloudflare_record" "logstash_a_record" {
  zone_id = data.cloudflare_zones.root_domain.id
  name    = "logstash.opencti-dev.${var.root_domain}"
  type    = "A"
  value   = "10.16.35.214"
  ttl     = 1
}
*/