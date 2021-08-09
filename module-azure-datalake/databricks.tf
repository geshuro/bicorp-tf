data "azurerm_databricks_workspace" "dbw" {
  count               = local.create_databricks_count
  name                = var.databricks_workspace_name
  resource_group_name = var.databricks_workspace_resource_group_name != "" ? var.databricks_workspace_resource_group_name : var.resource_group_name
}

resource "azurerm_role_assignment" "spdbw" {
  count                = local.create_databricks_count
  scope                = data.azurerm_databricks_workspace.dbw[count.index].id
  role_definition_name = "Owner"
  principal_id         = var.service_principal_object_id
}

resource "databricks_instance_pool" "pool" {
  count                                 = local.create_databricks_count
  instance_pool_name                    = "dbp-${var.data_lake_name}-${var.environment}-001"
  min_idle_instances                    = var.databricks_pool_min_idle_instances
  max_capacity                          = var.databricks_pool_max_capacity_instances
  node_type_id                          = var.databricks_cluster_node_type
  idle_instance_autotermination_minutes = var.databricks_pool_idle_instance_autotermination_minutes
  enable_elastic_disk                   = var.databricks_pool_enable_elastic_disk
  preloaded_spark_versions              = [var.databricks_cluster_version]
}

resource "databricks_cluster" "cluster" {
  count                   = local.create_databricks_count
  depends_on              = [azurerm_role_assignment.spdbw]
  spark_version           = var.databricks_cluster_version
  cluster_name            = "dbc-${var.data_lake_name}-${var.environment}-001"
  autotermination_minutes = var.databricks_cluster_autotermination_minutes
  instance_pool_id        = databricks_instance_pool.pool[count.index].id

  autoscale {
    min_workers = var.databricks_min_workers
    max_workers = var.databricks_max_workers
  }

  dynamic "cluster_log_conf" {
    for_each = var.databricks_log_path == "" ? [] : [var.databricks_log_path]
    content {
      dbfs {
        destination = cluster_log_conf.value
      }
    }
  }
}

resource "databricks_secret_scope" "dbsc" {
  count                    = local.create_databricks_count
  depends_on               = [azurerm_role_assignment.spdbw]
  name                     = "dbsc-${var.data_lake_name}-${var.environment}-001"
  initial_manage_principal = "users"
}

resource "databricks_secret" "dbs" {
  count        = local.create_databricks_count
  depends_on   = [azurerm_role_assignment.spdbw]
  key          = "dbs-${var.data_lake_name}-${var.environment}-001"
  string_value = var.service_principal_client_secret
  scope        = databricks_secret_scope.dbsc[count.index].name
}

resource "databricks_token" "dbt" {
  count      = local.create_databricks_count
  depends_on = [azurerm_role_assignment.spdbw]
  comment    = "Terraform Databricks service communication in ${var.data_lake_name}-${var.environment}"
}

resource "databricks_azure_adls_gen2_mount" "fs" {
  for_each               = local.create_databricks_bool ? toset(var.data_lake_filesystems) : toset([])
  container_name         = each.key
  storage_account_name   = azurerm_storage_account.dls.name
  mount_name             = each.key
  tenant_id              = data.azurerm_client_config.current.tenant_id
  client_id              = var.service_principal_client_id
  client_secret_scope    = databricks_secret.dbs[0].scope
  client_secret_key      = databricks_secret.dbs[0].key
  cluster_id             = databricks_cluster.cluster[0].id
  initialize_file_system = true
  depends_on             = [azurerm_storage_data_lake_gen2_filesystem.dlfs, azurerm_role_assignment.spsa_sa_dls, azurerm_role_assignment.spdbw]
}