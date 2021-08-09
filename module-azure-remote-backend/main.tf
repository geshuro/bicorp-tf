# Create a Resource Group for the Terraform State File
resource "azurerm_resource_group" "rg-state" {
  name                      = "rg-${var.project}-tfstate-${var.environment}-${var.sequential_number}"
  location                  = var.region
  lifecycle {
    prevent_destroy         = true
  }
  tags                      = var.tags
}
# Create a Storage Account for the Terraform State File
resource "azurerm_storage_account" "st-state" {
  depends_on                = [azurerm_resource_group.rg-state]
  name                      = "st${var.tfstate_name}${var.sequential_number}"
  resource_group_name       = azurerm_resource_group.rg-state.name
  account_kind              = var.account_kind
  account_tier              = var.account_tier
  access_tier               = var.access_tier
  account_replication_type  = var.account_replication_type
  enable_https_traffic_only = true
  location                  = var.region
  lifecycle {
    prevent_destroy         = true
  }
  tags                      = var.tags
}
# Create a Storage Container for the State File
resource "azurerm_storage_container" "stc-state" {
  depends_on                = [azurerm_storage_account.st-state]
  name                      = "stc${var.tfstate_name}${var.sequential_number}"
  storage_account_name      = azurerm_storage_account.st-state.name
  container_access_type     = "private"
}