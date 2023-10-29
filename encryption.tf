locals {
  cmk_condition = anytrue([var.managed_services_cmk_enabled, var.managed_disk_cmk_enabled])
}

# Key Vault access policy for Global Databricks Service Principal. Used for Managed Services and Managed Disk encryption with CMK
resource "azurerm_key_vault_access_policy" "databricks_ws_service" {
  count = alltrue([var.sku == "premium", local.cmk_condition]) ? 1 : 0

  key_vault_id       = var.key_vault_id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = var.global_databricks_object_id
  key_permissions    = var.key_vault_key_permissions
  secret_permissions = var.key_vault_secret_permissions

  lifecycle {
    precondition {
      condition     = alltrue([local.cmk_condition, var.key_vault_id != null])
      error_message = "To encrypt Databricks Workspace Services or Disk, please provide for key_vault_id variable, which points to Key Vault, where CMK key would be created"
    }
  }
}

# Key Vault access policy for Databricks Workspace Storage Account Managed Disk Identity. Used for Disk encryption with CMK
resource "azurerm_key_vault_access_policy" "databricks_ws_disk" {
  count = alltrue([var.sku == "premium", var.managed_disk_cmk_enabled, var.managed_disk_cmk_policy_enabled]) ? 1 : 0

  key_vault_id    = var.key_vault_id
  tenant_id       = azurerm_databricks_workspace.this.managed_disk_identity[0].tenant_id
  object_id       = azurerm_databricks_workspace.this.managed_disk_identity[0].principal_id
  key_permissions = var.key_vault_key_permissions

  lifecycle {
    precondition {
      condition     = alltrue([var.managed_disk_cmk_enabled, var.key_vault_id != null])
      error_message = "To encrypt Databricks Workspace Disk, please provide for key_vault_id variable, which points to Key Vault, where CMK key would be created"
    }
  }
}

# Key Vault access policy for Databricks Workspace Storage Account Managed Identity. Used for DBFS encryption with CMK
resource "azurerm_key_vault_access_policy" "databricks_storage_account_msi" {
  count = alltrue([var.sku == "premium", var.managed_dbfs_cmk_enabled]) ? 1 : 0

  key_vault_id    = var.key_vault_id
  tenant_id       = azurerm_databricks_workspace.this.storage_account_identity[0].tenant_id
  object_id       = azurerm_databricks_workspace.this.storage_account_identity[0].principal_id
  key_permissions = var.key_vault_key_permissions

  depends_on = [azurerm_databricks_workspace.this]

  lifecycle {
    precondition {
      condition     = alltrue([var.managed_dbfs_cmk_enabled, var.key_vault_id != null])
      error_message = "To encrypt Databricks Workspace DBFS, please provide for key_vault_id variable, which points to Key Vault, where CMK key would be created"
    }
  }
}

# DBFS encryption with CMK
resource "azurerm_databricks_workspace_root_dbfs_customer_managed_key" "this" {
  count = alltrue([var.sku == "premium", var.managed_dbfs_cmk_enabled]) ? 1 : 0

  workspace_id     = azurerm_databricks_workspace.this.id
  key_vault_key_id = var.managed_dbfs_cmk_key_vault_key_id

  depends_on = [azurerm_key_vault_access_policy.databricks_storage_account_msi]

  lifecycle { ignore_changes = [key_vault_key_id] } # Used for automated keys rotation
}
