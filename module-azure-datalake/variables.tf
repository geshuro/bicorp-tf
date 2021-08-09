variable "id" {
  type        = string
  description = "Unique identifier of the deployment"
  default     = ""
}
variable "data_lake_name" {
  type        = string
  description = "Name of the data lake"
}
variable "environment" {
  type        = string
  description = "This variable defines the environment to be built (dev=stg, pre, prod)"
  default     = "stg"
}
variable "region" {
  type        = string
  description = "Region in which to create the resources"
  default     = "eastus"
}
variable "data_lake_filesystems" {
  type        = list(string)
  description = "A list of filesystems to create inside the storage account"
  default     = ["raw", "curated", "serving"]
}
variable "databricks_cluster_version" {
  type        = string
  description = "Runtime version of the Databricks cluster"
  default     = "8.4.x-scala2.12"
  /*  Documentation
      https://docs.databricks.com/release-notes/runtime/8.4.html
  */
}
variable "provision_db" {
  description = "Set this to false to disable the creation of the db Analytics instance."
  default     = true
}
variable "extra_tags" {
  type        = map(string)
  description = "Extra tags that you would like to add to all created resources."
  default     = {}
}
variable "provision_data_factory_links" {
  description = "Set this to false to disable the creation of linked services inside Data Factory."
  default     = true
}
variable "databricks_log_path" {
  type        = string
  description = "Optional dbfs path where the Databricks cluster should store logs. The path should start with `dbfs:/`"
  default     = ""
}
variable "use_log_analytics" {
  description = "Set this to true to store logs in Log Analytics"
  default     = false
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
#Standard_F4s = 4 vcpus, 8GiB memory
variable "databricks_cluster_node_type" {
  type        = string
  description = "Node type of the Databricks cluster machines"
  default     = "Standard_F4s"
}
variable "databricks_min_workers" {
  type        = number
  description = "Minimum amount of workers in an active cluster"
  default     = 1
}
variable "databricks_max_workers" {
  type        = number
  description = "Maximum amount of workers in an active cluster"
  default     = 2
}
variable "service_principal_client_id" {
  type        = string
  description = "Client ID of the existing service principal that will be used for communication between services"
}
variable "service_principal_object_id" {
  type        = string
  description = "Object ID of the existing service principal that will be used for communication between services"
}
variable "service_principal_client_secret" {
  type        = string
  description = "Client secret of the existing service principal that will be used for communication between services"
}
variable "sql_server_admin_username" {
  type        = string
  description = "Username of the administrator of the SQL server"
  default     = null
}
variable "sql_server_admin_password" {
  type        = string
  description = "Password of the administrator of the SQL server"
  default     = null
}
variable "use_key_vault" {
  description = "Set this to true to enable the usage of your existing Key Vault"
  default     = false
}
variable "extra_storage_contributor_ids" {
  type        = list(string)
  description = "Extra contributors to the storage account"
  default     = []
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
variable "provision_databricks_resources" {
  description = "Set this to true to provision all Databricks related resources."
  default     = false
}
variable "databricks_workspace_name" {
  type        = string
  description = "Due to changes in how Terraform modules can use provider configurations, the module is not able to provision a Databricks workspace. Please provide the name of a Databricks workspace here to setup all Databricks related features. Also make sure to correctly configure the Terraform Databricks provider."
  default     = ""
}
variable "databricks_workspace_resource_group_name" {
  type        = string
  description = "Due to changes in how Terraform modules can use provider configurations, the module is not able to provision a Databricks workspace. Please provide the name the resource group of a Databricks workspace here to setup all Databricks related features. By default it will use the resource_group_name variable. Also make sure to correctly configure the Terraform Databricks provider."
  default     = ""
}
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where the resources should be created"
}
variable "mssql_version" {
  type        = string
  description = "The version of the MSSQL Server"
  default     = "12.0"
}
variable "ssl_minimal_tls_version_enforced" {
  type        = string
  description = "The mimimun TLS version to support on the sever"
  default     = "1.2"
}
variable "mssql_database_sku" {
  type        = string
  description = "The type of sku"
  default     = "S0"
}
variable "mssql_firewallrule_start_ip_address" {
  type        = string
  description = "Firewall rule start ip address"
  default     = "0.0.0.0"
}
variable "mssql_firewallrule_end_ip_address" {
  type        = string
  description = "Firewall rule end ip address"
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