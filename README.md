# Azure Databricks Workspace Terraform module
Terraform module for creation Azure Databricks Workspace

## Usage
This module provides an ability to deploy Azure Databricks Workspace. Here is an example how to provision Azure Databricks Workspace in managed network.

Currently, it is only possible to provision Databricks Workspace in managed network with help of this module.

```hcl
# Prerequisite resources for Databricks Workspace Deployment
data "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  resource_group_name = "example-rg"
  location            = "eastus"
}

data "azurerm_network_security_group" "default_nsg" {
  name                = "example-eastus-sg"
  resource_group_name = "example-rg"
}

data "azurerm_key_vault" "example" {
  name                = "example-key-vault"
  resource_group_name = "example-rg"
}

data "azurerm_key_vault_key" "example" {
  name         = "cmk-example"
  key_vault_id = data.azurerm_key_vault.example.id
}

data "azurerm_log_analytics_workspace" "example" {
  name                = "example"
  resource_group_name = "example-rg"
}

module "databricks_public" {
  source  = "data-platform-hq/subnet/azurerm"
  version = "~> 1.0"

  name                = "databricks-public"
  resource_group_name = "example-rg"
  network             = data.azurerm_virtual_network.example.name
  cidr                = cidrsubnet(data.azurerm_virtual_network.example.address_space[0], 6, 0) 
  nsg_id              = data.azurerm_network_security_group.default_nsg.id

  delegations = [{
    name = "Microsoft.Databricks/workspaces"
    actions = [
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
    ]
  }]
}

module "databricks_private" {
  source  = "data-platform-hq/subnet/azurerm"
  version = "~> 1.0"

  name                = "databricks-private"
  resource_group_name = "example-rg"
  network             = data.azurerm_virtual_network.example.name
  cidr                = cidrsubnet(data.azurerm_virtual_network.example.address_space[0], 6, 1) 
  nsg_id              = data.azurerm_network_security_group.default_nsg.id

  delegations = [{
    name = "Microsoft.Databricks/workspaces"
    actions = [
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
    ]
  }]
}

# Databricks Workspace module usage with prerequisite resources mentioned above
module "databricks_workspace" {
  source  = "data-platform-hq/databricks-ws/azurerm"
  version = "~> 1.0"

  workspace_name              = "example-workspace"
  location                    = "eastus"
  sku                         = "premium"
  resource_group              = "example-rg"
  managed_resource_group_name = "example-managed-rg"

  # Custom resources names
  access_connector_name = "example-databricks-connector"
  diagnostics_name      = "example-databricks-diagnostics"

  # Vnet injection block
  network_id                        = data.azurerm_virtual_network.example.id
  public_subnet_name                = module.databricks_public.name
  private_subnet_name               = module.databricks_private.name
  public_subnet_nsg_association_id  = module.databricks_public.nsg_association_id
  private_subnet_nsg_association_id = module.databricks_private.nsg_association_id
  nsg_rules_required                = "AllRules"

  # CMK Encryption
  key_vault_id     = data.azurerm_key_vault.example.id
  
  # Databricks Services encryption
  managed_services_cmk_enabled          = true
  managed_services_cmk_key_vault_key_id = data.azurerm_key_vault_key.example.id

  # Data Plane Cluster Disks CMK Encryption
  managed_disk_cmk_enabled          = true
  managed_disk_cmk_policy_enabled   = true
  managed_disk_cmk_key_vault_key_id = data.azurerm_key_vault_key.example.id

  # DBFS
  managed_dbfs_cmk_enabled          = true
  managed_dbfs_cmk_key_vault_key_id = data.azurerm_key_vault_key.example.id

  # Other
  access_connector_enabled = true
  log_analytics_workspace  = { (data.azurerm_log_analytics_workspace.example.name) = data.azurerm_log_analytics_workspace.example.id }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_databricks_access_connector.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_access_connector) | resource |
| [azurerm_databricks_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace) | resource |
| [azurerm_databricks_workspace_root_dbfs_customer_managed_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace_root_dbfs_customer_managed_key) | resource |
| [azurerm_key_vault_access_policy.databricks_storage_account_msi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.databricks_ws_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.databricks_ws_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_monitor_diagnostic_categories.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) | data source |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_connector_enabled"></a> [access\_connector\_enabled](#input\_access\_connector\_enabled) | Provides an ability to provision Databricks Access Connector which is required for Unity Catalog feature | `bool` | `true` | no |
| <a name="input_access_connector_name"></a> [access\_connector\_name](#input\_access\_connector\_name) | Databricks Access Connector optional name | `string` | `null` | no |
| <a name="input_analytics_destination_type"></a> [analytics\_destination\_type](#input\_analytics\_destination\_type) | Log analytics destination type | `string` | `"Dedicated"` | no |
| <a name="input_diagnostics_name"></a> [diagnostics\_name](#input\_diagnostics\_name) | Diagnostic Settings optional name | `string` | `null` | no |
| <a name="input_global_databricks_object_id"></a> [global\_databricks\_object\_id](#input\_global\_databricks\_object\_id) | Global 'AzureDatabricks' SP object id | `string` | `"9b38785a-6e08-4087-a0c4-20634343f21f"` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | Key Vault ID | `string` | `null` | no |
| <a name="input_key_vault_key_permissions"></a> [key\_vault\_key\_permissions](#input\_key\_vault\_key\_permissions) | List of key vault key permissions for Databricks Global Service Principal | `list(string)` | <pre>[<br/>  "Get",<br/>  "List",<br/>  "Encrypt",<br/>  "Decrypt",<br/>  "WrapKey",<br/>  "UnwrapKey",<br/>  "GetRotationPolicy"<br/>]</pre> | no |
| <a name="input_key_vault_secret_permissions"></a> [key\_vault\_secret\_permissions](#input\_key\_vault\_secret\_permissions) | List of key vault secret permissions for Databricks Global Service Principal | `list(string)` | <pre>[<br/>  "Get",<br/>  "List"<br/>]</pre> | no |
| <a name="input_location"></a> [location](#input\_location) | Azure location | `string` | n/a | yes |
| <a name="input_log_analytics_workspace"></a> [log\_analytics\_workspace](#input\_log\_analytics\_workspace) | Log Analytics Workspace Name to ID map | `map(string)` | `{}` | no |
| <a name="input_managed_dbfs_cmk_enabled"></a> [managed\_dbfs\_cmk\_enabled](#input\_managed\_dbfs\_cmk\_enabled) | Boolean flag that determines whether Workspace DBFS is encrypted with CMK key | `bool` | `false` | no |
| <a name="input_managed_dbfs_cmk_key_vault_key_id"></a> [managed\_dbfs\_cmk\_key\_vault\_key\_id](#input\_managed\_dbfs\_cmk\_key\_vault\_key\_id) | Key Vault key ID used for Databricks DBFS encryption | `string` | `null` | no |
| <a name="input_managed_disk_cmk_enabled"></a> [managed\_disk\_cmk\_enabled](#input\_managed\_disk\_cmk\_enabled) | Boolean flag that determines whether Data Plane Disks are encrypted with CMK key | `bool` | `false` | no |
| <a name="input_managed_disk_cmk_key_vault_key_id"></a> [managed\_disk\_cmk\_key\_vault\_key\_id](#input\_managed\_disk\_cmk\_key\_vault\_key\_id) | Key Vault key ID used for Data Plane Disks encryption | `string` | `null` | no |
| <a name="input_managed_disk_cmk_policy_enabled"></a> [managed\_disk\_cmk\_policy\_enabled](#input\_managed\_disk\_cmk\_policy\_enabled) | Create Key Vault Policy for Databricks Workspace Managed Disk identity.<br/>Upon initial creation of Workspace with Disk CMK encryption, Disk Encryption Set with managed identity is created, it is used for cluster's disks encryption.<br/><br/>However, if Workspace already provisioned and have to updated to use Managed Disk encryption, then 'Disk Encryption Set' is known after creation.<br/>Which means, that you have to first apply with 'managed\_disk\_cmk\_enabled = true' only and set 'managed\_disk\_cmk\_policy\_enabled' to false, because identity is unknown.<br/>On next apply, set 'managed\_disk\_cmk\_policy\_enabled' to true, because identity of Managed Disk is created and known. | `bool` | `true` | no |
| <a name="input_managed_resource_group_name"></a> [managed\_resource\_group\_name](#input\_managed\_resource\_group\_name) | The name of the managed resource group | `string` | `null` | no |
| <a name="input_managed_services_cmk_enabled"></a> [managed\_services\_cmk\_enabled](#input\_managed\_services\_cmk\_enabled) | Encrypts Databricks Workspaces Services like Notebooks and Queries, once CMK type of encryption is enabled it won't be possible to switch back to default Microsoft Managed Encryption. | `bool` | `false` | no |
| <a name="input_managed_services_cmk_key_vault_key_id"></a> [managed\_services\_cmk\_key\_vault\_key\_id](#input\_managed\_services\_cmk\_key\_vault\_key\_id) | Key Vault key ID used for Databricks Managed Services encryption | `string` | `null` | no |
| <a name="input_managed_storage_account_identity_enabled"></a> [managed\_storage\_account\_identity\_enabled](#input\_managed\_storage\_account\_identity\_enabled) | Prerequisite for DBFS encryption. Enabled managed Storage Account identity to create Key Vault Policy to access encryption keys | `bool` | `true` | no |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | The ID of a Virtual Network where this Databricks Cluster should be created | `string` | n/a | yes |
| <a name="input_no_public_ip"></a> [no\_public\_ip](#input\_no\_public\_ip) | Are public IP Addresses not allowed?: [true\|false] | `bool` | `true` | no |
| <a name="input_nsg_rules_required"></a> [nsg\_rules\_required](#input\_nsg\_rules\_required) | Does the data plane to control plane communication happen over private link endpoint only or publicly?: [AllRules, NoAzureDatabricksRules, NoAzureServiceRules] | `string` | `"AllRules"` | no |
| <a name="input_private_subnet_name"></a> [private\_subnet\_name](#input\_private\_subnet\_name) | The name of the Private Subnet within the Virtual Network. Required if virtual\_network\_id is set | `string` | n/a | yes |
| <a name="input_private_subnet_nsg_association_id"></a> [private\_subnet\_nsg\_association\_id](#input\_private\_subnet\_nsg\_association\_id) | The resource ID of the azurerm\_subnet\_network\_security\_group\_association resource which is referred to by the private\_subnet\_name field. Required if virtual\_network\_id is set | `string` | n/a | yes |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Allow public access for accessing workspace: [true\|false] | `bool` | `true` | no |
| <a name="input_public_subnet_name"></a> [public\_subnet\_name](#input\_public\_subnet\_name) | The name of the Public Subnet within the Virtual Network. Required if virtual\_network\_id is set | `string` | n/a | yes |
| <a name="input_public_subnet_nsg_association_id"></a> [public\_subnet\_nsg\_association\_id](#input\_public\_subnet\_nsg\_association\_id) | The resource ID of the azurerm\_subnet\_network\_security\_group\_association resource which is referred to by the public\_subnet\_name field. Required if virtual\_network\_id is set | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | The name of the resource group in which to create the storage account | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | The sku to use for the Databricks Workspace: [standard\|premium\|trial] | `string` | `"premium"` | no |
| <a name="input_storage_firewall_enabled"></a> [storage\_firewall\_enabled](#input\_storage\_firewall\_enabled) | Boolean flag that determines whether public access is disallowed | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_workspace_name"></a> [workspace\_name](#input\_workspace\_name) | Databricks Workspace name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_connector_id"></a> [access\_connector\_id](#output\_access\_connector\_id) | Databricks Access Connector's Id |
| <a name="output_access_connector_identity"></a> [access\_connector\_identity](#output\_access\_connector\_identity) | Databricks Access Connector's Identities list |
| <a name="output_databricks_client_id_identity"></a> [databricks\_client\_id\_identity](#output\_databricks\_client\_id\_identity) | The Client ID of the User Assigned Identity. |
| <a name="output_databricks_disk_encryption_set_id"></a> [databricks\_disk\_encryption\_set\_id](#output\_databricks\_disk\_encryption\_set\_id) | The ID of Managed Disk Encryption Set created by the Databricks Workspace. |
| <a name="output_databricks_managed_storage_account_id"></a> [databricks\_managed\_storage\_account\_id](#output\_databricks\_managed\_storage\_account\_id) | Azure Databricks Workspace Managed Storage Account ID. |
| <a name="output_databricks_principal_id_identity"></a> [databricks\_principal\_id\_identity](#output\_databricks\_principal\_id\_identity) | The Service Principal ID of the User Assigned Identity. |
| <a name="output_id"></a> [id](#output\_id) | Azure Databricks Resource ID |
| <a name="output_sku"></a> [sku](#output\_sku) | Azure Databricks Workspace SKU type |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | Azure Databricks Workspace ID |
| <a name="output_workspace_url"></a> [workspace\_url](#output\_workspace\_url) | Azure Databricks Workspace URL |
<!-- END_TF_DOCS -->

## License

Apache 2 Licensed. For more information please see [LICENSE](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/blob/main/LICENSE)
