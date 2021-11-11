terraform {
  required_providers {
    tls = {
      source = "hashicorp/tls"
      version = "3.1.0"
    }
  }
  backend "consul" {
    path = "tls"
    address = "127.0.0.1:8500"
    scheme = "http"
  }
  required_version = "~> 0.13.5"
}