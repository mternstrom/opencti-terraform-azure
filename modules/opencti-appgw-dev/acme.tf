resource "tls_private_key" "acme_registration_key" {
  algorithm   = "RSA"
  rsa_bits    = 4096 
}

resource "acme_registration" "acme_account" {
  provider          = acme.vancluever-acme
  email_address     = var.dns_cloudflare_email
  account_key_pem   = tls_private_key.acme_registration_key.private_key_pem
}

/*
data "external" "wait_for_txt_propagation" {
  program = ["sh", "-c", "sleep 120"]
  depends_on = [cloudflare_record.acme_challenge_txt_record]
}

resource "time_sleep" "txt_record_propagation" {
  triggers = {
    record_value = cloudflare_record.acme_challenge_txt_record.value
    }
  create_duration = "2m"
}
*/

resource "acme_certificate" "appgw_cert" {
  depends_on = [
    acme_registration.acme_account,
    #cloudflare_record.a_record,
    #cloudflare_record.www_a_record,
    #cloudflare_record.opencti_dev_a_record,
    #cloudflare_record.elasticsearch_a_record,
    #cloudflare_record.kibana_a_record,
    #cloudflare_record.logstash_a_record,
  ]

  provider          = acme.vancluever-acme
  account_key_pem   = acme_registration.acme_account.account_key_pem

  common_name = local.full_domain
  subject_alternative_names = [
    local.full_domain, 
    "*.${local.full_domain}"
    ]

  dns_challenge {
    provider = "cloudflare"
    config = {
      CLOUDFLARE_EMAIL = var.dns_cloudflare_email
      CLOUDFLARE_API_KEY = var.dns_cloudflare_api_key
    }
 }
}

data "external" "convert_frontend_cert" {
  depends_on = [acme_certificate.appgw_cert]

  program = ["bash", "-c", "openssl pkcs12 -export -inkey <(echo '${base64encode(acme_certificate.appgw_cert.private_key_pem)}' | base64 -d) -in <(echo '${base64encode(acme_certificate.appgw_cert.certificate_pem)}' | base64 -d) -certfile <(echo '${base64encode(acme_certificate.appgw_cert.issuer_pem)}' | base64 -d) -out /dev/stdout | jq -R -s '{\"stdout\": .}'"]
  #program = ["bash", "-c", "openssl pkcs12 -export -inkey <(echo '${base64encode(acme_certificate.appgw_cert.private_key_pem)}' | base64 -d) -in <(echo '${base64encode(acme_certificate.appgw_cert.certificate_pem)}' | base64 -d) -certfile <(echo '${base64encode(acme_certificate.appgw_cert.issuer_pem)}' base64 -d) -passoin pass:${var.frontend_cert_password} | base64 -w 0 | jq -R -c '{\"stdout\": .}'"]
}

data "external" "convert_backend_cert" {
  depends_on = [acme_certificate.appgw_cert]

  program = ["bash", "-c", "openssl x509 -outform der -in <(echo '${base64encode(acme_certificate.appgw_cert.certificate_pem)}' | base64 -d) | base64 -w 0 | jq -R -c '{\"stdout\": .}'"]
}

data "external" "fullchain_pem" {
  depends_on = [acme_certificate.appgw_cert]

  program = ["bash", "-c", "echo '${base64encode(acme_certificate.appgw_cert.certificate_pem)}' | base64 -w 0 | jq -R -c '{\"stdout\": .}'"]
}

data "external" "cert_pem" {
  depends_on = [acme_certificate.appgw_cert]

  program = ["bash", "-c", "echo '${base64encode(acme_certificate.appgw_cert.private_key_pem)}' | base64 -w 0 | jq -R -c '{\"stdout\": .}'"]
}

data "external" "chain_pem" {
  depends_on = [acme_certificate.appgw_cert]

  program = ["bash", "-c", "echo '${base64encode(acme_certificate.appgw_cert.issuer_pem)}' | base64 -w 0 | jq -R -c '{\"stdout\": .}'"]
}
