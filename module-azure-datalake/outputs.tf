output "name" {
  description = "Name of the data lake"
  value       = var.data_lake_name
}

output "sql_dw_server_hostname" {
  description = "Name of the SQL server that hosts the Azure db Analytics instance"
  value       = var.provision_db == 1 ? azurerm_mssql_server.sql[0].fully_qualified_domain_name : ""
}

output "sql_dw_server_database" {
  description = "Name of the Azure db Analytics instance"
  value       = var.provision_db == 1 ? azurerm_mssql_database.sqldb[0].name : ""
}

output "created_key_vault_secrets" {
  description = "Secrets that have been created inside the optional Key Vault with their versions"
  value       = local.created_secrets_all
}

output "storage_dfs_endpoint" {
  description = "Primary DFS endpoint of the created storage account"
  value       = azurerm_storage_account.dls.primary_dfs_endpoint
}

output "data_factory_name" {
  description = "Name of the created Data Factory"
  value       = azurerm_data_factory.adf.name
}

output "data_factory_identity" {
  description = "Object ID of the managed identity of the created Data Factory"
  value       = azurerm_data_factory.adf.identity[0].principal_id
}

output "data_factory_id" {
  description = "Resource ID of the Data Factory"
  value       = azurerm_data_factory.adf.id
}

### Databricks instance pool
output "databricks_instancepool_id" {
  description = "returns a string"
  value       = databricks_instance_pool.pool.*.id
}
output "databricks_instancepool_name" {
  description = "returns a string"
  value       = databricks_instance_pool.pool.*.instance_pool_name
}
output "databricks_instancepool_maxcapacity" {
  description = "returns a string"
  value       = databricks_instance_pool.pool.*.max_capacity
}
output "databricks_instancepool_nodetypeid" {
  description = "returns a string"
  value       = databricks_instance_pool.pool.*.node_type_id
}


### Databricks cluster
output "databricks_cluster_id" {
  description = "returns a string"
  value       = databricks_cluster.cluster.*.id
}
output "databricks_cluster_name" {
  description = "returns a string"
  value       = databricks_cluster.cluster.*.cluster_name
}
output "databricks_cluster_sparkversion" {
  description = "returns a string"
  value       = databricks_cluster.cluster.*.spark_version
}
output "databricks_cluster_autoterminationminutes" {
  description = "returns a string"
  value       = databricks_cluster.cluster.*.autotermination_minutes
}
output "databricks_cluster_instancepoolid" {
  description = "returns a string"
  value       = databricks_cluster.cluster.*.instance_pool_id
}
/*
output "databricks_cluster_autoscaleminworkers" {
  description = "returns a string"
  value       = databricks_cluster.cluster.*.autoscale.min_workers
}
output "databricks_cluster_autoscalemaxworkers" {
  description = "returns a string"
  value       = databricks_cluster.cluster.*.autoscale.max_workers
}
*/
### SQL Server
output "sqlserver_id" {
  description = "returns a string"
  value       = azurerm_mssql_server.sql.*.id
}
output "sqlserver_name" {
  description = "returns a string"
  value       = azurerm_mssql_server.sql.*.name
}
output "sqlserver_minimumtlsversion" {
  description = "returns a string"
  value       = azurerm_mssql_server.sql.*.minimum_tls_version
}
output "sqlserver_administratorlogin" {
  description = "returns a string"
  value       = azurerm_mssql_server.sql.*.administrator_login
}
### Database
output "sqldatabase_id" {
  description = "returns a string"
  value       = azurerm_mssql_database.sqldb.*.id
}
output "sqldatabase_name" {
  description = "returns a string"
  value       = azurerm_mssql_database.sqldb.*.name
}
output "sqldatabase_sku" {
  description = "returns a string"
  value       = azurerm_mssql_database.sqldb.*.sku_name
}
output "sqldatabase_serverid" {
  description = "returns a string"
  value       = azurerm_mssql_database.sqldb.*.server_id
}
### SQL Server Firewall
output "sqlserver_firewall_id" {
  description = "returns a string"
  value       = azurerm_mssql_firewall_rule.sqlfwr-allow.*.id
}
output "sqlserver_firewall_name" {
  description = "returns a string"
  value       = azurerm_mssql_firewall_rule.sqlfwr-allow.*.name
}
output "sqlserver_firewall_serverid" {
  description = "returns a string"
  value       = azurerm_mssql_firewall_rule.sqlfwr-allow.*.server_id
}
output "sqlserver_firewall_startipaddress" {
  description = "returns a string"
  value       = azurerm_mssql_firewall_rule.sqlfwr-allow.*.start_ip_address
}
output "sqlserver_firewall_endipaddress" {
  description = "returns a string"
  value       = azurerm_mssql_firewall_rule.sqlfwr-allow.*.end_ip_address
}
### Key Vault
output "key_vault_id" {
  description = "returns a string"
  value       = azurerm_key_vault.kv.id
}
output "key_vault_name" {
  description = "returns a string"
  value       = azurerm_key_vault.kv.name
}
output "key_vault_sku" {
  description = "returns a string"
  value       = azurerm_key_vault.kv.sku_name
}
output "key_vault_soft_delete_retention_days" {
  description = "returns a string"
  value       = azurerm_key_vault.kv.soft_delete_retention_days
}
output "key_vault_secret_databricks_token" {
  description = "returns a string"
  value       = azurerm_key_vault_secret.databricks_token.*.name
}
output "key_vault_secret_storagea_dl" {
  description = "returns a string"
  value       = azurerm_key_vault_secret.storagea_dl.*.name
}
output "key_vault_secret_sql" {
  description = "returns a string"
  value       = azurerm_key_vault_secret.sql.*.name
}
### Log analytics
output "log_analytics_workspace_name" {
  description = "Resource Name of the log analytics workspace"
  value       = azurerm_log_analytics_workspace.logw.name
}
output "log_analytics_workspace_id" {
  description = "Resource ID of the log analytics workspace"
  value       = azurerm_log_analytics_workspace.logw.id
}
output "monitor_diagnostic_logs_id" {
  description = "Resource ID of the log analytics workspace"
  value       = azurerm_monitor_diagnostic_setting.adf.*.id
}
output "monitor_diagnostic_logs_name" {
  description = "Resource Name of the log analytics workspace"
  value       = azurerm_monitor_diagnostic_setting.adf.*.name
}
### Storage account
output "storage_account_id" {
  description = "Resource storage account type Datalake"
  value       = azurerm_storage_account.dls.id
}
output "storage_account_name" {
  description = "Name of the created storage account for ADLS"
  value       = azurerm_storage_account.dls.name
}
output "storage_account_replication_type" {
  description = "Resource storage account type Datalake"
  value       = azurerm_storage_account.dls.account_replication_type
}
output "storage_account_tier" {
  description = "Resource storage account type Datalake"
  value       = azurerm_storage_account.dls.account_tier
}
output "storage_access_tier" {
  description = "Resource storage account type Datalake"
  value       = azurerm_storage_account.dls.access_tier
}
output "storage_is_hns_enabled" {
  description = "Resource storage account type Datalake"
  value       = azurerm_storage_account.dls.is_hns_enabled
}
/*
output "storage_data_lake_gen2_filesystem" {
  description = "Resource storage account type Datalake"
  value       = azurerm_storage_data_lake_gen2_filesystem.dlfs.*.name
}
*/