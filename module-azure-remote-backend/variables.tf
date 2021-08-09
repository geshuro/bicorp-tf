variable "project" {
  type = string
  description = "This variable defines the name of the project"
  default = "bicorp"
}
# environment
variable "environment" {
  type        = string
  description = "This variable defines the environment to be built (dev=stg, pre, prod)"
  default     = "stg"
}
# azure region
variable "region" {
  type = string
  description = "Azure region where resources will be created"
  default = "eastus"
}
# account kind
variable "account_kind" {
  type = string
  description = "Kind storage account"
  default = "StorageV2"
}
# account tier
variable "account_tier" {
  type = string
  description = "Tier storage account"
  default = "Standard"
}
# access tier
variable "access_tier" {
  type = string
  description = "Tier access account"
  default = "Hot"
}
# account replication type
variable "account_replication_type" {
  type = string
  description = "Account replication type"
  default = "ZRS"
}
# tfstate name
variable "tfstate_name" {
  type = string
  description = "Name of tfstate"
  default = ""
}
# sequential number
variable "sequential_number" {
  type = string
  description = "Sequential number"
  default = "001"
}
# map tags
variable "tags" {
  type        = map(string)
  description = "Name of map tags"
  default     = {}
}