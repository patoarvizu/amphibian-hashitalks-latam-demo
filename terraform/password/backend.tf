terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
  }
  backend "consul" {
    path = "password"
    address = "127.0.0.1:8500"
    scheme = "http"
  }
  required_version = "~> 0.13.5"
}