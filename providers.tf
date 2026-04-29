terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
  # These two lines help bypass the "JSON input" and "Cache" errors
  resource_provider_registrations = "none"
  skip_provider_registration      = true
}