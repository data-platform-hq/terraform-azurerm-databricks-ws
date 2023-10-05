data "azurerm_monitor_diagnostic_categories" "this" {
  for_each = var.sku == "premium" ? var.log_analytics_workspace : {}

  resource_id = azurerm_databricks_workspace.this.id
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.sku == "premium" ? var.log_analytics_workspace : {}

  name                           = coalesce(var.diagnostics_name, "monitoring-${var.workspace_name}") #local.diagnostics_name
  target_resource_id             = azurerm_databricks_workspace.this.id
  log_analytics_workspace_id     = each.value
  log_analytics_destination_type = var.analytics_destination_type

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.this[each.key].log_category_types
    content {
      category = enabled_log.value
    }
  }

  lifecycle {
    ignore_changes = [log_analytics_destination_type] # TODO remove when issue is fixed: https://github.com/Azure/azure-rest-api-specs/issues/9281
  }
}
