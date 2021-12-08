terraform {
  required_version = ">= 0.12.26"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = ">= 1.2"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 2.1.0"
    }
  }
}
