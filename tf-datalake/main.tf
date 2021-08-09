provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = false
    }
  }
}

resource "random_string" "id" {
  length  = 4
  upper   = false
  special = false
}

resource "azurerm_resource_group" "rg" {
  location = var.region
  name     = "rg-${local.data_lake_name}-dl-${var.environment}-001"
  tags     = local.tags
}

resource "azurerm_databricks_workspace" "dbw" {
  name                        = "dbw-${local.data_lake_name}-${var.environment}"
  resource_group_name         = azurerm_resource_group.rg.name
  managed_resource_group_name = "rg-${local.data_lake_name}-db-${var.environment}-001"
  location                    = var.region
  sku                         = var.databricks_workspace_sku
  tags                        = local.tags
}

provider "databricks" {
  azure_workspace_resource_id = azurerm_databricks_workspace.dbw.id
}

resource "azuread_application" "sp" {
  display_name = "id-app-${local.data_lake_name}-${var.environment}-${var.region}-001"
  required_resource_access {
    resource_app_id = "e406a681-f3d4-42a8-90b6-c2b029497af1"
    /*
    "appDisplayName": "Azure Storage",
    "appId": "e406a681-f3d4-42a8-90b6-c2b029497af1"
    */
    resource_access {
      /* azureStorageUserImpersonationPermissionId */
      id   = "03e0da56-190b-40ad-a80c-ea378c433f7f"
      type = "Scope"
    }
  }
  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"
    /*
    "appDisplayName": "Microsoft Graph",
    "appId": "00000003-0000-0000-c000-000000000000"
    */
    resource_access {
      /* microsoftGraphUserReadPermissionId */
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }
  }
}

resource "random_password" "sp" {
  length = 64
}

resource "azuread_service_principal" "sp" {
  application_id        = azuread_application.sp.application_id
  tags                  = [local.data_lake_name]
}

resource "azuread_service_principal_password" "sp" {
  service_principal_id  = azuread_service_principal.sp.id
  value                 = random_password.sp.result
  end_date_relative     = "240h"
}

module "azure-datalake" {
  depends_on                                = [azurerm_databricks_workspace.dbw]
  source                                    = __#{sourceAzureDatalake}#__
  data_lake_name                            = local.data_lake_name
  region                                    = var.region
  storage_replication                       = var.storage_replication
  resource_group_name                       = azurerm_resource_group.rg.name
  service_principal_client_id               = azuread_application.sp.application_id
  service_principal_client_secret           = azuread_service_principal_password.sp.value
  service_principal_object_id               = azuread_service_principal.sp.object_id
  databricks_workspace_name                 = azurerm_databricks_workspace.dbw.name
  sql_server_admin_username                 = var.sql_server_admin_username
  sql_server_admin_password                 = var.sql_server_admin_password
  provision_databricks_resources            = var.provision_databricks_resources
  provision_db                              = var.provision_db
  use_key_vault                             = var.use_key_vault
  use_log_analytics                         = var.use_log_analytics
  mssql_database_sku                        = var.mssql_database_sku
  mssql_firewallrule_start_ip_address       = var.mssql_firewallrule_start_ip_address
  mssql_firewallrule_end_ip_address         = var.mssql_firewallrule_end_ip_address
  keyvault_sku_name                         = var.keyvault_sku_name
  keyvault_soft_delete_retention_days       = var.keyvault_soft_delete_retention_days
  keyvault_purge_protection_enabled         = var.keyvault_purge_protection_enabled
  log_analytics_workspace_sku               = var.log_analytics_workspace_sku
  log_analytics_workspace_retention_in_days = var.log_analytics_workspace_retention_in_days
  monitor_log_analytics_destination_type    = var.monitor_log_analytics_destination_type
  storage_account_account_tier              = var.storage_account_account_tier
  storage_account_access_tier               = var.storage_account_access_tier
  storage_account_is_hns_enabled            = var.storage_account_is_hns_enabled
  databricks_pool_min_idle_instances        = var.databricks_pool_min_idle_instances
  databricks_pool_max_capacity_instances    = var.databricks_pool_max_capacity_instances
  databricks_pool_idle_instance_autotermination_minutes = var.databricks_pool_idle_instance_autotermination_minutes
  databricks_pool_enable_elastic_disk       = var.databricks_pool_enable_elastic_disk
  databricks_cluster_autotermination_minutes = var.databricks_cluster_autotermination_minutes
  data_lake_filesystems                     = var.data_lake_filesystems
  dl_directories                            = var.dl_directories
  dl_acl                                    = var.dl_acl
  id                                        = local.id
  environment                               = var.environment
  extra_tags                                = local.tags
}


module "security-center" {
  depends_on                                = [module.azure-datalake.log_analytics_workspace_id]
  source                                    = __#{sourceAzureSecurityCenter}#__
  resource_group_name                       = azurerm_resource_group.rg.name
  log_analytics_workspace_name              = module.azure-datalake.log_analytics_workspace_name
  enable_security_center_setting            = var.enable_security_center_setting
  security_center_setting_name              = var.security_center_setting_name
  enable_security_center_auto_provisioning  = var.enable_security_center_auto_provisioning
  security_center_contacts = {
    email               = var.security_center_contacts_emails
    phone               = var.security_center_contacts_phone
    alert_notifications = var.security_center_contacts_alert_notifications
    alerts_to_admins    = var.security_center_contacts_alerts_to_admins
  }
}