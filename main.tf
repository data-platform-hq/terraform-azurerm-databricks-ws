data "azurerm_client_config" "current" {}

resource "azurerm_databricks_workspace" "this" {
  name                                                = var.workspace_name
  resource_group_name                                 = var.resource_group
  location                                            = var.location
  managed_resource_group_name                         = "${var.resource_group}-databricks"
  sku                                                 = var.sku
  public_network_access_enabled                       = var.public_network_access_enabled
  network_security_group_rules_required               = var.nsg_rules_required
  tags                                                = var.tags
  managed_services_cmk_key_vault_key_id               = alltrue([var.sku == "premium", var.managed_services_cmk_enabled]) ? var.managed_services_cmk_key_vault_key_id : null
  managed_disk_cmk_key_vault_key_id                   = alltrue([var.sku == "premium", var.managed_disk_cmk_enabled]) ? var.managed_disk_cmk_key_vault_key_id : null
  managed_disk_cmk_rotation_to_latest_version_enabled = alltrue([var.sku == "premium", var.managed_disk_cmk_enabled]) ? true : null

  # Creates Storage Account identity used for DBFS encryption
  customer_managed_key_enabled = alltrue([var.sku == "premium", var.managed_storage_account_identity_enabled]) ? true : false

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

  name                = coalesce(var.access_connector_name, "ac-${var.workspace_name}") #local.access_connector_name
  resource_group_name = var.resource_group
  location            = var.location
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }
}
