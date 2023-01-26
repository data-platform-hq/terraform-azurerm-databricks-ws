locals {
  suffix = length(var.suffix) == 0 ? "" : "-${var.suffix}"
}

resource "azurerm_databricks_workspace" "this" {
  name                                  = "dbw-${var.project}-${var.env}-${var.location}${local.suffix}"
  resource_group_name                   = var.resource_group
  location                              = var.location
  managed_resource_group_name           = "${var.resource_group}-databricks"
  sku                                   = var.sku
  public_network_access_enabled         = var.public_network_access_enabled
  network_security_group_rules_required = var.nsg_rules_required
  tags                                  = var.tags

  custom_parameters {
    no_public_ip                                         = var.no_public_ip
    virtual_network_id                                   = var.network_id
    public_subnet_name                                   = var.public_subnet_name
    private_subnet_name                                  = var.private_subnet_name
    public_subnet_network_security_group_association_id  = var.public_subnet_nsg_association_id
    private_subnet_network_security_group_association_id = var.private_subnet_nsg_association_id
  }
}

resource "azurerm_databricks_access_connector" "this" {
  count = var.access_connector_enabled ? 1 : 0

  name                = "ac-${var.project}-${var.env}-${var.location}${var.suffix}"
  resource_group_name = var.resource_group
  location            = var.location
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.sku == "premium" ? { for k, v in var.log_analytics_workspace : k => v } : {}

  name                           = "monitoring-${var.project}-${var.env}-${var.location}{local.suffix}"
  target_resource_id             = azurerm_databricks_workspace.this.id
  log_analytics_workspace_id     = each.value
  log_analytics_destination_type = var.destination_type

  dynamic "enabled_log" {
    for_each = var.log_category_list
    content {
      category = enabled_log.value

      retention_policy {
        enabled = true
        days    = var.log_retention_days
      }
    }
  }
}
