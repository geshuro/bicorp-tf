terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.32.0"
    }
    databricks = {
      source  = "databrickslabs/databricks"
      version = ">= 0.2.8"
    }
    random = {
      source = "hashicorp/random"
    }
  }

  backend "azurerm" {
  } 

  required_version = ">= 0.13"
}