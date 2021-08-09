### Databricks workspace
output "databricks_id" {
  description = "returns a string"
  value       = azurerm_databricks_workspace.dbw.id
}
output "databricks_workspace_sku" {
  description = "returns a string"
  value       = azurerm_databricks_workspace.dbw.sku
}
output "databricks_workspace_id" {
  description = "returns a string"
  value       = azurerm_databricks_workspace.dbw.workspace_id
}
output "databricks_workspace_url" {
  description = "returns a string"
  value       = azurerm_databricks_workspace.dbw.workspace_url
}
### Databricks instance pool
output "databricks_instancepool_id" {
  description = "returns a string"
  value       = module.azure-datalake.databricks_instancepool_id
}
output "databricks_instancepool_name" {
  description = "returns a string"
  value       = module.azure-datalake.databricks_instancepool_name
}
output "databricks_instancepool_maxcapacity" {
  description = "returns a string"
  value       = module.azure-datalake.databricks_instancepool_maxcapacity
}
output "databricks_instancepool_nodetypeid" {
  description = "returns a string"
  value       = module.azure-datalake.databricks_instancepool_nodetypeid
}
### Databricks cluster
output "databricks_cluster_id" {
  description = "returns a string"
  value       = module.azure-datalake.databricks_cluster_id
}
output "databricks_cluster_name" {
  description = "returns a string"
  value       = module.azure-datalake.databricks_cluster_name
}
output "databricks_cluster_sparkversion" {
  description = "returns a string"
  value       = module.azure-datalake.databricks_cluster_sparkversion
}
output "databricks_cluster_autoterminationminutes" {
  description = "returns a string"
  value       = module.azure-datalake.databricks_cluster_autoterminationminutes
}
output "databricks_cluster_instancepoolid" {
  description = "returns a string"
  value       = module.azure-datalake.databricks_cluster_instancepoolid
}
### Datafactory
output "data_factory_name" {
  description = "Name of the created Data Factory"
  value       = module.azure-datalake.data_factory_name
}
output "data_factory_identity" {
  description = "Object ID of the managed identity of the created Data Factory"
  value       = module.azure-datalake.data_factory_identity
}
output "data_factory_id" {
  description = "Resource ID of the Data Factory"
  value       = module.azure-datalake.data_factory_id
}
### SQL Server
output "sqlserver_id" {
  description = "returns a string"
  value       = module.azure-datalake.sqlserver_id
}
output "sqlserver_name" {
  description = "returns a string"
  value       = module.azure-datalake.sqlserver_name
}
output "sqlserver_minimumtlsversion" {
  description = "returns a string"
  value       = module.azure-datalake.sqlserver_minimumtlsversion
}
output "sqlserver_administratorlogin" {
  description = "returns a string"
  value       = module.azure-datalake.sqlserver_administratorlogin
}
### Database
output "sqldatabase_id" {
  description = "returns a string"
  value       = module.azure-datalake.sqldatabase_id
}
output "sqldatabase_name" {
  description = "returns a string"
  value       = module.azure-datalake.sqldatabase_name
}
output "sqldatabase_sku" {
  description = "returns a string"
  value       = module.azure-datalake.sqldatabase_sku
}
output "sqldatabase_serverid" {
  description = "returns a string"
  value       = module.azure-datalake.sqldatabase_serverid
}
output "sqldatabase_hostname" {
  description = "Name of the SQL server that hosts the Azure db Analytics instance"
  value       = module.azure-datalake.sql_dw_server_hostname
}
### SQL Server Firewall
output "sqlserver_firewall_id" {
  description = "returns a string"
  value       = module.azure-datalake.sqlserver_firewall_id
}
output "sqlserver_firewall_name" {
  description = "returns a string"
  value       = module.azure-datalake.sqlserver_firewall_name
}
output "sqlserver_firewall_serverid" {
  description = "returns a string"
  value       = module.azure-datalake.sqlserver_firewall_serverid
}
output "sqlserver_firewall_startipaddress" {
  description = "returns a string"
  value       = module.azure-datalake.sqlserver_firewall_startipaddress
}
output "sqlserver_firewall_endipaddress" {
  description = "returns a string"
  value       = module.azure-datalake.sqlserver_firewall_endipaddress
}
### Key Vault
output "key_vault_id" {
  description = "returns a string"
  value       = module.azure-datalake.key_vault_id
}
output "key_vault_name" {
  description = "returns a string"
  value       = module.azure-datalake.key_vault_name
}
output "key_vault_sku" {
  description = "returns a string"
  value       = module.azure-datalake.key_vault_sku
}
output "key_vault_soft_delete_retention_days" {
  description = "returns a string"
  value       = module.azure-datalake.key_vault_soft_delete_retention_days
}
output "key_vault_secret_databricks_token" {
  description = "returns a string"
  value       = module.azure-datalake.key_vault_secret_databricks_token
}
output "key_vault_secret_storagea_dl" {
  description = "returns a string"
  value       = module.azure-datalake.key_vault_secret_storagea_dl
}
output "key_vault_secret_sql" {
  description = "returns a string"
  value       = module.azure-datalake.key_vault_secret_sql
}
output "created_key_vault_secrets" {
  description = "Secrets that have been created inside the optional Key Vault with their versions"
  value       = module.azure-datalake.created_key_vault_secrets
}
### Log analytics
output "log_analytics_workspace_name" {
  description = "Resource Name of the log analytics workspace"
  value       = module.azure-datalake.log_analytics_workspace_name
}
output "log_analytics_workspace_id" {
  description = "Resource ID of the log analytics workspace"
  value       = module.azure-datalake.log_analytics_workspace_id
}
output "monitor_diagnostic_logs_id" {
  description = "Resource ID of the log analytics workspace"
  value       = module.azure-datalake.monitor_diagnostic_logs_id
}
output "monitor_diagnostic_logs_name" {
  description = "Resource Name of the log analytics workspace"
  value       = module.azure-datalake.monitor_diagnostic_logs_name
}
### Storage account
output "storage_account_id" {
  description = "Resource storage account type Datalake"
  value       = module.azure-datalake.storage_account_id
}
output "storage_account_name" {
  description = "Resource storage account type Datalake"
  value       = module.azure-datalake.storage_account_name
}
output "storage_account_replication_type" {
  description = "Resource storage account type Datalake"
  value       = module.azure-datalake.storage_account_replication_type
}
output "storage_account_tier" {
  description = "Resource storage account type Datalake"
  value       = module.azure-datalake.storage_account_tier
}
output "storage_access_tier" {
  description = "Resource storage account type Datalake"
  value       = module.azure-datalake.storage_access_tier
}
output "storage_is_hns_enabled" {
  description = "Resource storage account type Datalake"
  value       = module.azure-datalake.storage_is_hns_enabled
}
output "storage_dfs_endpoint" {
  description = "Primary DFS endpoint of the created storage account"
  value       = module.azure-datalake.storage_dfs_endpoint
}