variable "id" {
  type        = string
  description = "Unique identifier of the deployment"
  default     = ""
}
variable "project" {
  type = string
  description = "This variable defines the name of the project"
  default = "bicorp"
}
variable "region" {
  type        = string
  description = "Region where the resources will be created"
  default     = "eastus"
}
variable "environment" {
  type        = string
  description = "This variable defines the environment to be built (dev=stg, pre, prod)"
  default     = "stg"
}
variable "databricks_workspace_sku" {
  type        = string
  description = "Type SKU Databricks ws"
  default     = "standard"
}
variable "sql_server_admin_username" {
  type        = string
  description = "Name admin SQL server"
  default     = "admdatalake"
}
variable "sql_server_admin_password" {
  type        = string
  description = "Password admin SQL server"
  default     = ""
}
variable "provision_databricks_resources" {
  description = "Provision of Databricks resources"
  default     = false
}
variable "provision_db" {
  description = "Provision Azure Data Base"
  default     = false
}
variable "use_key_vault" {
  description = "Use Azure Key Vault"
  default     = false
}
variable "use_log_analytics" {
  description = "Use Log analytics"
  default     = false
}
variable "enable_security_center_setting" {
  description = "Enable Secutiry center setting"
  default     = false
}
variable "security_center_setting_name" {
  type        = string
  description = "Type security center setting"
  default     = "MCAS"
}
variable "enable_security_center_auto_provisioning" {
  type        = string
  description = "Enable Auto provisioning Security center"
  default     = "On"
}
variable "security_center_contacts_emails" {
  type        = string
  description = "Emails for Center contacts"
  default     = "sys.ayd1@sqm.com"
}
variable "security_center_contacts_phone" {
  type        = string
  description = "Number of phone for contact"
  default     = "+56952098765"
}
variable "security_center_contacts_alert_notifications" {
  description = "Enable alert of notificacions in security center"
  default     = false
}
variable "security_center_contacts_alerts_to_admins" {
  description = "Enable alert to admins in security center"
  default     = false
}
variable "mssql_database_sku" {
  type        = string
  description = "The type of sku of SQL Server"
  default     = "S0"
}
variable "mssql_firewallrule_start_ip_address" {
  type        = string
  description = "Firewall rule start ip address of SQL Server"
  default     = "0.0.0.0"
}
variable "mssql_firewallrule_end_ip_address" {
  type        = string
  description = "Firewall rule end ip address of SQL Server"
  default     = "0.0.0.0"
}
variable "keyvault_sku_name" {
  type        = string
  description = "Key Vault Sku name"
  default     = "standard"
}
variable "keyvault_soft_delete_retention_days" {
  type        = number
  description = "Key Vault Soft delete retention days"
  default     = 7
}
variable "keyvault_purge_protection_enabled" {
  description = "Key Vault Purge protection enabled"
  default     = false
}
variable "log_analytics_workspace_sku" {
  type        = string
  description = "Log analytics workspace Sku name"
  default     = "Free"
}
variable "log_analytics_workspace_retention_in_days" {
  type        = number
  description = "Log analytics workspace retention in days"
  default     = 7
}
variable "monitor_log_analytics_destination_type" {
  type        = string
  description = "Monitor log analytics destination type"
  default     = "Dedicated"
}
variable "storage_account_account_tier" {
  type        = string
  description = "Storage account account tier"
  default     = "Standard"
}
variable "storage_account_access_tier" {
  type        = string
  description = "Storage account access tier"
  default     = "Cool"
}
variable "storage_replication" {
  type        = string
  description = "Type of replication for the storage accounts. See https://www.terraform.io/docs/providers/azurerm/r/storage_account.html#account_replication_type"
  default     = "LRS"
}
variable "storage_account_is_hns_enabled" {
  description = "Enable hierarchical namespace. See https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-namespace , https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-cli#create-a-storage-account-1"
  default     = true
}
variable "databricks_pool_min_idle_instances" {
  type        = number
  description = "The minimum number of idle instances maintained by the pool. This is in addition to any instances in use by active clusters."
  default     = 0
}
variable "databricks_pool_max_capacity_instances" {
  type        = number
  description = "The maximum number of instances the pool can contain, including both idle instances and ones in use by clusters."
  default     = 3
}
variable "databricks_pool_idle_instance_autotermination_minutes" {
  type        = number
  description = "The number of minutes that idle instances in excess of the min_idle_instances are maintained by the pool before being terminated."
  default     = 10
}
variable "databricks_pool_enable_elastic_disk" {
  description = "Autoscaling Local Storage: when enabled, the instances in the pool dynamically acquire additional disk space when they are running low on disk space."
  default     = true
}
variable "databricks_cluster_autotermination_minutes" {
  type        = number
  description = "Automatically terminate the cluster after being inactive for this time in minutes."
  default     = 20
}
variable "data_lake_filesystems" {
  type        = list(string)
  description = "A list of filesystems to create inside the storage account"
  default     = ["raw", "curated", "serving"]
}
variable "dl_acl" {
  type        = map(string)
  description = "Optional set of ACL to set on the filesystem roots inside the data lake. This is applied before dl_directories. The value is a map where the key is the name of the filesytem and the value is the ACL to set."
  default     = {
    serving = "user::rwx,group::rwx,other::rwx"
  }
}
variable "dl_directories" {
  type        = map(map(string))
  description = "Optional root directories to be created inside the data lake. The value is a map where the keys are the names of the filesystems. The values are maps as well. In these nested maps, the keys are the names of the directories and the values are the ACL to set. Leave this empty to not set any ACL explicitly."
  default     = {
    raw = { 
      raw1 = "user::rwx,group::rwx,other::rwx"
      raw2 = "user::rwx,group::r--,other::---" 
    }
    curated = { 
      curated1 = "user::rwx,group::rwx,other::rwx"
      curated2 = "user::rwx,group::r--,other::---" 
    }
    serving = { 
      serving1 = "user::rwx,group::rwx,other::rwx"
      serving2 = "user::rwx,group::r--,other::---" 
    }
  }
}