locals {
  suffix = length(var.suffix) == 0 ? "" : "-${var.suffix}"
}

data "azurerm_client_config" "current" {}

resource "azurerm_databricks_workspace" "this" {
  name                                  = "dbw-${var.project}-${var.env}-${var.location}${local.suffix}"
  resource_group_name                   = var.resource_group
  location                              = var.location
  managed_resource_group_name           = "${var.resource_group}-databricks"
  sku                                   = var.sku
  public_network_access_enabled         = var.public_network_access_enabled
  network_security_group_rules_required = var.nsg_rules_required
  tags                                  = var.tags
  managed_services_cmk_key_vault_key_id = var.sku == "premium" && var.customer_managed_service_key_enabled ? azurerm_key_vault_key.databricks_ws_service[0].id : null

  custom_parameters {
    no_public_ip                                         = var.no_public_ip
    virtual_network_id                                   = var.network_id
    public_subnet_name                                   = var.public_subnet_name
    private_subnet_name                                  = var.private_subnet_name
    public_subnet_network_security_group_association_id  = var.public_subnet_nsg_association_id
    private_subnet_network_security_group_association_id = var.private_subnet_nsg_association_id
  }
  depends_on = [azurerm_key_vault_access_policy.databricks_ws_service]
}

resource "azurerm_databricks_access_connector" "this" {
  count = var.access_connector_enabled ? 1 : 0

  name                = "ac-${var.project}-${var.env}-${var.location}${local.suffix}"
  resource_group_name = var.resource_group
  location            = var.location
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_monitor_diagnostic_categories" "this" {
  for_each = var.sku == "premium" ? var.log_analytics_workspace : {}

  resource_id = azurerm_databricks_workspace.this.id
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.sku == "premium" ? var.log_analytics_workspace : {}

  name                           = "monitoring-${var.project}-${var.env}-${var.location}${local.suffix}"
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

resource "azurerm_key_vault_key" "databricks_ws_service" {
  count = var.sku == "premium" && var.customer_managed_service_key_enabled ? 1 : 0

  name         = "databricks-managed-services-cmk"
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  lifecycle {
    precondition {
      condition = alltrue([var.customer_managed_service_key_enabled, var.key_vault_id != null])
      error_message = "To encrypt Databricks Workspace Services, please provide for key_vault_id variable, which points to Key Vault, where CMK key would be created" 
    }
  }

}

resource "azurerm_key_vault_access_policy" "databricks_ws_service" {
  count = var.sku == "premium" && var.customer_managed_service_key_enabled ? 1 : 0

  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.global_databricks_object_id
  key_permissions = [
    "Get",
    "List",
    "Encrypt",
    "Decrypt",
    "WrapKey",
    "UnwrapKey"
  ]

  lifecycle {
    precondition {
      condition = alltrue([var.customer_managed_service_key_enabled, var.key_vault_id != null])
      error_message = "To encrypt Databricks Workspace Services, please provide for key_vault_id variable, which points to Key Vault, where CMK key would be created" 
    }
  }

}
