terraform {
  required_version = ">= 1.1.8"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14"
    }

    http = {
      source  = "hashicorp/http"
      version = ">= 3.1.0"
    }
  }
}
