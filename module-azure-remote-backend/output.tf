output "tfstate_rg" {
  value = azurerm_resource_group.rg-state.name
}
output "tfstate_st" {
  value = azurerm_storage_account.st-state.name
}
output "tfstate_stc" {
  value = azurerm_storage_container.stc-state.name
}