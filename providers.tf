terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # THIS IS THE MISSING PIECE
  backend "azurerm" {} 
}

provider "azurerm" {
  features {}
}