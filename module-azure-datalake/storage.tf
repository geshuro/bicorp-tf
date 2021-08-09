resource "azurerm_storage_account" "dls" {
  name                     = "dls${var.data_lake_name}${var.region}${var.environment}001"
  location                 = var.region
  resource_group_name      = var.resource_group_name
  account_tier             = var.storage_account_account_tier
  access_tier              = var.storage_account_access_tier
  is_hns_enabled           = var.storage_account_is_hns_enabled
  account_replication_type = var.storage_replication
  tags                     = local.common_tags
}

resource "azurerm_role_assignment" "spsa_sa_dls" {
  scope                = azurerm_storage_account.dls.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.service_principal_object_id
}

resource "azurerm_role_assignment" "current_user_sa_dls" {
  scope                = azurerm_storage_account.dls.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "extra_contributor" {
  count                = length(var.extra_storage_contributor_ids)
  scope                = azurerm_storage_account.dls.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.extra_storage_contributor_ids[count.index]
}

resource "azurerm_role_assignment" "adf_sa_dls" {
  scope                = azurerm_storage_account.dls.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_data_factory.adf.identity[0].principal_id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "dlfs" {
  for_each           = toset(var.data_lake_filesystems)
  name               = each.key
  storage_account_id = azurerm_storage_account.dls.id
  depends_on         = [azurerm_role_assignment.current_user_sa_dls]
}

resource "local_file" "sa_set_acl" {
  content = templatefile("${path.module}/files/sa_acl.sh", {
    "filesystems" = keys(var.dl_acl)
    "fs_acls"     = var.dl_acl
  })
  filename = "${path.module}/files/set_acl.sh"
}

resource "null_resource" "sa_set_acl" {
  depends_on = [azurerm_role_assignment.current_user_sa_dls, azurerm_storage_data_lake_gen2_filesystem.dlfs]
  triggers = {
    "acl" = local_file.sa_set_acl.content
  }

  provisioner "local-exec" {
    command = local_file.sa_set_acl.filename
    environment = {
      "AZURE_STORAGE_KEY"       = azurerm_storage_account.dls.primary_access_key
      "AZURE_STORAGE_ACCOUNT"   = azurerm_storage_account.dls.name
      "AZURE_STORAGE_AUTH_MODE" = "key"
    }
  }
}

resource "local_file" "sa_create_directories" {
  content = templatefile("${path.module}/files/sa_directories.sh", {
    "filesystems"  = keys(var.dl_directories)
    "fs_dirs_acls" = var.dl_directories
  })
  filename = "${path.module}/files/create_directories.sh"
}

resource "null_resource" "sa_create_directories" {
  depends_on = [null_resource.sa_set_acl, azurerm_role_assignment.current_user_sa_dls, azurerm_storage_data_lake_gen2_filesystem.dlfs]
  triggers = {
    "directories" = local_file.sa_create_directories.content
  }

  provisioner "local-exec" {
    command = local_file.sa_create_directories.filename
    environment = {
      "AZURE_STORAGE_KEY"       = azurerm_storage_account.dls.primary_access_key
      "AZURE_STORAGE_ACCOUNT"   = azurerm_storage_account.dls.name
      "AZURE_STORAGE_AUTH_MODE" = "key"
    }
  }
}