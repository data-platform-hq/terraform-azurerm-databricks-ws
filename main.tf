resource "azurerm_databricks_workspace" "this" {
  name                                  = "dbw-${var.project}-${var.env}-${var.location}${var.suffix}"
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
