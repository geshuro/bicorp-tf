provider "azurerm" {
  features {
  }
}

module "azure-remote-backend" {
  source                    = __#{sourceAzureRemoteBackend}#__
  tfstate_name              = local.tfstate_name
  sequential_number         = var.sequential_number
  environment               = var.environment
  region                    = var.region
  account_kind              = var.account_kind
  account_tier              = var.account_tier
  access_tier               = var.access_tier
  account_replication_type  = var.account_replication_type
  project                   = var.project
  tags                      = local.tags
}