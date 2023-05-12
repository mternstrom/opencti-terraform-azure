terraform {
  required_providers {
    acme = {
      source = "vancluever/acme",
      version = "~> 2.13.1",
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 4.2.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~> 4.0.4"
    }
    external = {
      source = "hashicorp/external"
      version = "~> 2.3.1"
    }
  }
}

module "acme_certificate" {
  source = "git::https://github.com/vancluever/terraform-provider-acme"
}

provider "acme" {
  alias = "vancluever-acme"  
  server_url = local.acme_url
}

provider "cloudflare" {
  #dns_cloudflare_api_token = "${env.CLOUDFLARE_API_TOKEN}"
  email   = var.dns_cloudflare_email
  api_key = var.dns_cloudflare_api_key
}