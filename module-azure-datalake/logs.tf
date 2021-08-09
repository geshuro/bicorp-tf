resource "azurerm_log_analytics_workspace" "logw" {
  name                = "logw-${var.data_lake_name}-${var.region}-${var.environment}-001"
  location            = var.region
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.log_analytics_workspace_retention_in_days
}

resource "azurerm_monitor_diagnostic_setting" "adf" {
  count                          = var.use_log_analytics ? 1 : 0
  name                           = "mnd-adf-${var.data_lake_name}-${var.environment}-001"
  target_resource_id             = azurerm_data_factory.adf.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.logw.id
  log_analytics_destination_type = var.monitor_log_analytics_destination_type

  metric {
    enabled  = true
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 14
    }
  }

  log {
    enabled  = true
    category = "TriggerRuns"

    retention_policy {
      enabled = true
      days    = 14
    }
  }

  log {
    enabled  = true
    category = "ActivityRuns"

    retention_policy {
      enabled = true
      days    = 14
    }
  }

  log {
    enabled  = true
    category = "PipelineRuns"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
}
