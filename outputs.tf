output "id" {
  value       = azurerm_databricks_workspace.this.id
  description = "Azure Databricks Resource ID"
}

output "workspace_url" {
  value       = azurerm_databricks_workspace.this.workspace_url
  description = "Azure Databricks Workspace URL"
}

output "workspace_id" {
  value       = azurerm_databricks_workspace.this.workspace_id
  description = "Azure Databricks Workspace ID"
}

output "sku" {
  value       = var.sku
  description = "Azure Databricks Workspace SKU type"
}

output "access_connector_id" {
  value       = try(azurerm_databricks_access_connector.this[0].id, null)
  description = "Databricks Access Connector's Id"
}

output "access_connector_identity" {
  value       = try(azurerm_databricks_access_connector.this[0].identity[*], null)
  description = "Databricks Access Connector's Identities list"
}

output "databricks_principal_id_identity" {
  value       = data.azurerm_user_assigned_identity.this.principal_id
  description = "The Service Principal ID of the User Assigned Identity."
}

output "databricks_client_id_identity" {
  value       = data.azurerm_user_assigned_identity.this.client_id
  description = "The Client ID of the User Assigned Identity."
}
