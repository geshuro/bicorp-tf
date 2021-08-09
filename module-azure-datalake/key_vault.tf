resource "azurerm_key_vault" "kv" {
  name                        = "kv-${var.data_lake_name}-${var.id}-${var.environment}-001"
  location                    = var.region
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = var.keyvault_sku_name
  soft_delete_retention_days  = var.keyvault_soft_delete_retention_days
  purge_protection_enabled    = var.keyvault_purge_protection_enabled
  tags                        = local.common_tags

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
      "list",
      "get",
      "delete",
      "purge",
      "recover"
    ]
  }
}

resource "azurerm_key_vault_access_policy" "adf" {
  count              = local.use_kv
  key_vault_id       = azurerm_key_vault.kv.id
  tenant_id          = azurerm_data_factory.adf.identity[0].tenant_id
  object_id          = azurerm_data_factory.adf.identity[0].principal_id
  secret_permissions = ["list", "get"]
}

resource "azurerm_key_vault_secret" "databricks_token" {
  depends_on        = [azurerm_key_vault_access_policy.adf]
  count             = var.use_key_vault && local.create_databricks_bool ? 1 : 0
  name              = "kvs-dbt-${var.data_lake_name}-${var.environment}-001"
  value             = databricks_token.dbt[count.index].token_value
  key_vault_id      = azurerm_key_vault.kv.id
  tags              = local.common_tags
}

resource "azurerm_key_vault_secret" "storagea_dl" {
  depends_on        = [azurerm_key_vault_access_policy.adf]
  count             = local.use_kv
  name              = "kvs-stdl-${var.data_lake_name}-${var.environment}-001"
  value             = azurerm_storage_account.dls.primary_access_key
  key_vault_id      = azurerm_key_vault.kv.id
  tags              = local.common_tags
}

resource "azurerm_key_vault_secret" "sql" {
  depends_on        = [azurerm_key_vault_access_policy.adf]
  count             = local.use_kv
  name              = "kvs-sql-${var.data_lake_name}-${var.environment}-001"
  value             = var.sql_server_admin_password
  key_vault_id      = azurerm_key_vault.kv.id
  tags              = local.common_tags
}