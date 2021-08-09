resource "azurerm_mssql_server" "sql" {
  count                        = local.create_db_count
  name                         = "sql-${var.data_lake_name}-${var.environment}"
  location                     = var.region
  resource_group_name          = var.resource_group_name
  tags                         = local.common_tags
  version                      = var.mssql_version
  administrator_login          = var.sql_server_admin_username
  administrator_login_password = length(azurerm_key_vault_secret.sql) > 0 ? azurerm_key_vault_secret.sql[0].value : var.sql_server_admin_password
  minimum_tls_version          = var.ssl_minimal_tls_version_enforced
}

resource "azurerm_mssql_database" "sqldb" {
  count                        = local.create_db_count
  name                         = "sqldb-${var.data_lake_name}-${var.environment}"
  server_id                    = azurerm_mssql_server.sql[count.index].id
  tags                         = local.common_tags
  sku_name                     = var.mssql_database_sku
}

resource "azurerm_mssql_firewall_rule" "sqlfwr-allow" {
  count                        = local.create_db_count
  name                         = "sqlfwr-${var.data_lake_name}-${var.environment}-001"
  server_id                    = azurerm_mssql_server.sql[count.index].id
  start_ip_address             = var.mssql_firewallrule_start_ip_address
  end_ip_address               = var.mssql_firewallrule_end_ip_address
}