resource "azurerm_data_factory" "adf" {
  name                  = "adf-${var.data_lake_name}-${var.environment}"
  location              = var.region
  resource_group_name   = var.resource_group_name
  tags                  = local.common_tags
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "dls" {
  name                  = "adf-ls-dls-${var.data_lake_name}-${var.environment}-001"
  resource_group_name   = var.resource_group_name
  data_factory_name     = azurerm_data_factory.adf.name
  tenant                = data.azurerm_client_config.current.tenant_id
  url                   = azurerm_storage_account.dls.primary_dfs_endpoint
  service_principal_id  = var.service_principal_client_id
  service_principal_key = var.service_principal_client_secret
  depends_on            = [azurerm_role_assignment.spsa_sa_dls]
  count                 = local.create_data_factory_ls_count
  annotations           = local.list_common_tags
}

resource "azurerm_data_factory_linked_service_key_vault" "kv" {
  count                 = local.use_kv
  name                  = "adf-ls-kv-${var.data_lake_name}-${var.environment}-001"
  resource_group_name   = var.resource_group_name
  data_factory_name     = azurerm_data_factory.adf.name
  key_vault_id          = azurerm_key_vault.kv.id
  annotations           = local.list_common_tags
}

resource "azurerm_data_factory_linked_service_sql_server" "sql" {
  count                 = local.create_db_count
  name                  = "adf-ls-sql-${var.data_lake_name}-${var.environment}-001"
  resource_group_name   = var.resource_group_name
  data_factory_name     = azurerm_data_factory.adf.name
  annotations           = local.list_common_tags
  connection_string     = "Integrated Security=False;Data Source=${azurerm_mssql_server.sql[count.index].fully_qualified_domain_name};Initial Catalog=${azurerm_mssql_database.sqldb[count.index].name};User ID=${var.sql_server_admin_username};"
  key_vault_password {
    linked_service_name = azurerm_data_factory_linked_service_key_vault.kv[count.index].name
    secret_name         = azurerm_key_vault_secret.sql[count.index].name
  }
}

resource "azurerm_data_factory_linked_service_azure_sql_database" "sqldb" {
  count                 = local.create_db_count
  name                  = "adf-ls-sqldb-${var.data_lake_name}-${var.environment}-001"
  resource_group_name   = var.resource_group_name
  data_factory_name     = azurerm_data_factory.adf.name
  connection_string     = "data source=${azurerm_mssql_server.sql[count.index].fully_qualified_domain_name};initial catalog=${azurerm_mssql_database.sqldb[count.index].name};user id=${var.sql_server_admin_username};integrated security=False;encrypt=True;connection timeout=30"
  annotations           = local.list_common_tags
  key_vault_password {
    linked_service_name = azurerm_data_factory_linked_service_key_vault.kv[count.index].name
    secret_name         = azurerm_key_vault_secret.sql[count.index].name
  }
}

resource "azurerm_template_deployment" "dbls" {
  count               = local.create_databricks_bool && var.provision_data_factory_links ? 1 : 0
  name                = "adf-ls-db-${var.data_lake_name}-${var.environment}-001"
  resource_group_name = var.resource_group_name
  template_body       = file("${path.module}/files/lsdb.json")
  parameters = {
    "factoryName"                 = azurerm_data_factory.adf.name
    "accessToken"                 = databricks_token.dbt[count.index].token_value
    "domain"                      = format("https://%s", data.azurerm_databricks_workspace.dbw[count.index].workspace_url)
    "databricksLinkedServiceName" = data.azurerm_databricks_workspace.dbw[count.index].name
    "clusterId"                   = databricks_cluster.cluster[count.index].id
  }
  deployment_mode = "Incremental"
  provisioner "local-exec" {
    command    = "${path.module}/files/destroy_resource.sh"
    when       = destroy
    on_failure = continue
    environment = {
      RESOURCE_ID = self.outputs["databricksLinkedServiceId"]
    }
  }
}