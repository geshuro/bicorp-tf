locals {
  own_tags = {
    DataLake = var.data_lake_name
  }
  common_tags = merge(local.own_tags, var.extra_tags)
  list_common_tags = [for k, v in local.common_tags : "${k}.${v}"]

  create_db_count                    = var.provision_db ? 1 : 0
  create_data_factory_ls_count       = var.provision_data_factory_links ? 1 : 0
  create_databricks_count            = local.create_databricks_bool ? 1 : 0
  create_databricks_bool             = var.provision_databricks_resources
  use_kv                             = var.use_key_vault ? 1 : 0

  created_secrets_1 = var.use_key_vault ? {
    (azurerm_key_vault_secret.storagea_dl[0].name)      = azurerm_key_vault_secret.storagea_dl[0].version
  } : {}
  created_secrets_2 = var.use_key_vault && local.create_databricks_bool ? {
    (azurerm_key_vault_secret.databricks_token[0].name) = azurerm_key_vault_secret.databricks_token[0].version
  } : {}
  created_secrets_all = merge(local.created_secrets_1, local.created_secrets_2)
}
