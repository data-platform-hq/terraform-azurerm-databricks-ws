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
  name         = "example"
  key_vault_id = data.azurerm_key_vault.example.id
}

data "azurerm_log_analytics_workspace" "example" {
  name                = "example"
  resource_group_name = "example-rg"
}

module "databricks_public" {
  source  = "data-platform-hq/subnet/azurerm"

  name                = "databricks-public"
  resource_group_name = "example-rg"
  network             = data.azurerm_virtual_network.example.name
  cidr                = "10.1.0.0/22"
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

  name                = "databricks-private"
  resource_group_name = "example-rg"
  network             = data.azurerm_virtual_network.example.name
  cidr                = "10.1.4.0/22"
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

locals {
  log_analytics_workspace_map  = { 
    (data.azurerm_log_analytics_workspace.example.name) = data.azurerm_log_analytics_workspace.example.id
  }
}

# Databricks Workspace module usage with prerequisite resources mentioned above
module "databricks_workspace" {
  source  = "data-platform-hq/databricks-ws/azurerm"

  project        = "datahq"
  env            = "example"
  location       = "eastus"
  sku            = "premium"
  resource_group = "example-rg"

  # Custom resources names
  custom_workspace_name        = "dbw-example-workspace"
  custom_access_connector_name = "example-databricks-connector"
  custom_diagnostics_name      = "example-databricks-diagnostics"

  # Vnet injection block
  network_id                        = data.azurerm_virtual_network.example.id
  public_subnet_name                = module.databricks_public.name
  private_subnet_name               = module.databricks_private.name
  public_subnet_nsg_association_id  = module.databricks_public.nsg_association_id
  private_subnet_nsg_association_id = module.databricks_private.nsg_association_id
  nsg_rules_required                = "AllRules"

  # CMK Encryption
  customer_managed_service_key_enabled = true
  
  key_vault_id     = data.azurerm_key_vault.example.id
  key_vault_key_id = data.azurerm_key_vault_key.example.id

  # Other
  access_connector_enabled = false
  log_analytics_workspace  = local.log_analytics_workspace_map
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                      | Version   |
|---------------------------------------------------------------------------|-----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0  |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm)       | >= 3.40.0 |

## Providers

| Name                                                          | Version |
|---------------------------------------------------------------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.40.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                                                                | Type     |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| [data.azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config)                              | data     |
| [azurerm_databricks_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace)                           | resource |
| [azurerm_databricks_access_connector.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_access_connector)             | resource |
| [data.azurerm_monitor_diagnostic_categories.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) | resource |
| [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting)               | resource |
| [azurerm_key_vault_access_policy.databricks-ws_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy)    | resource |

## Inputs

| Name                                                                                                                                                   | Description                                                                                                                                                                             | Type           | Default                                                                                                                                                         | Required |
|--------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------:|
| <a name="input_project"></a> [project](#input\_project)                                                                                                | Project name                                                                                                                                                                            | `string`       | n/a                                                                                                                                                             |   yes    |
| <a name="input_env"></a> [env](#input\_env)                                                                                                            | Environment name                                                                                                                                                                        | `string`       | n/a                                                                                                                                                             |   yes    |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group)                                                                         | The name of the resource group in which to create the storage account                                                                                                                   | `string`       | n/a                                                                                                                                                             |   yes    |
| <a name="input_location"></a> [location](#input\_location)                                                                                             | Azure location                                                                                                                                                                          | `string`       | n/a                                                                                                                                                             |   yes    |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id)                                                                                     | The ID of a Virtual Network where this Databricks Cluster should be created                                                                                                             | `string`       | n/a                                                                                                                                                             |   yes    |
| <a name="input_public_subnet_name"></a> [public\_subnet\_name](#input\_public\_subnet\_name)                                                           | The name of the Public Subnet within the Virtual Network. Required if virtual_network_id is set                                                                                         | `string`       | n/a                                                                                                                                                             |   yes    |
| <a name="input_private_subnet_name"></a> [private\_subnet\_name](#input\_private\_subnet\_name)                                                        | The name of the Private Subnet within the Virtual Network. Required if virtual_network_id is set                                                                                        | `string`       | n/a                                                                                                                                                             |   yes    |
| <a name="input_public_subnet_nsg_association_id"></a> [public\_subnet\_nsg\_association\_id](#input\_public\_subnet\_nsg\_association\_id)             | The resource ID of the azurerm_subnet_network_security_group_association resource which is referred to by the public_subnet_name field. Required if virtual_network_id is set           | `string`       | n/a                                                                                                                                                             |   yes    |
| <a name="input_private_subnet_nsg_association_id"></a> [private\_subnet\_nsg\_association\_id](#input\_private\_subnet\_nsg\_association\_id)          | The resource ID of the azurerm_subnet_network_security_group_association resource which is referred to by the private_subnet_name field. Required if virtual_network_id is set          | `string`       | n/a                                                                                                                                                             |   yes    |
| <a name="input_custom_workspace_name"></a> [custom\_workspace\_name](#input\_custom\_workspace\_name)                                                  | Specifies the name of the Databricks Workspace resource                                                                                                                                 | `string`       | `null`                                                                                                                                                          |    no    |
| <a name="input_custom_access_connector_name"></a> [custom\_access\_connector\_name](#input\_custom\_access\_connector\_name)                           | Specifies the name of the Databricks Access Connector resource                                                                                                                          | `string`       | `null`                                                                                                                                                          |    no    |
| <a name="input_custom_diagnostics_name"></a> [custom\_diagnostics\_name](#input\_custom\_diagnostics\_name)                                            | Custom name for Diagnostic Settings that monitors Databricks Workspace                                                                                                                  | `string`       | `null`                                                                                                                                                          |    no    |
| <a name="input_suffix"></a> [suffix](#input\_suffix)| Optional suffix that would be added to the end of resources names. It is recommended to use dash at the beginning of variable (e.x., '-example')| `string`       | n/a|    no    |
| <a name="input_tags"></a> [tags](#input\_tags)| A mapping of tags to assign to the resource| `map(string)`  | {}|    no    |
| <a name="input_sku"></a> [sku](#input\_sku)| The sku to use for the Databricks Workspace: <pre>[standard \premium \ trial]</pre>                                                                                                     | `string`       | standard                                                                                                                                                        |    no    |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled)                        | Allow public access for accessing workspace: <pre>[true \ false] </pre>                                                                                                                 | `bool`         | true                                                                                                                                                            |    no    |
| <a name="input_no_public_ip"></a> [no\_public\_ip](#input\_no\_public\_ip)                                                                             | Are public IP Addresses not allowed?: <pre>[true \ false] </pre>                                                                                                                        | `bool`         | true                                                                                                                                                            |    no    |
| <a name="input_nsg_rules_required"></a> [nsg\_rules\_required](#input\_nsg\_rules\_required)                                                           | Does the data plane to control plane communication happen over private link endpoint only or publicly?: <pre>[AllRules \ NoAzureDatabricksRules \ NoAzureServiceRules] </pre>           | `string`       | AllRules                                                                                                                                                        |    no    |
| <a name="input_access_connector_enabled"></a> [access\_connector\_enabled](#input\_access\_connector\_enabled)                                         | Provides an ability to provision Databricks Access Connector which is required for Unity Catalog feature                                                                                | `bool`         | false                                                                                                                                                           |    no    |
| <a name="input_log_analytics_workspace"></a> [log\_analytics\_workspace](#input\_log\_analytics\_workspace) | Log Analytics Workspace Name to ID map | `map(string)`  | {} |    no    |
| <a name="input_analytics_destination_type"></a> [analytics\_destination\_type](#input\_analytics\_destination\_type) | Log analytics destination type | `string`  | Dedicated |    no    |
| <a name="input_customer_managed_service_key_enabled"></a> [customer\_managed\_service\_key\_enabled](#input\_customer\_managed\_service\_key\_enabled) | Encrypts Databricks Workspaces Services like Notebooks and Queries, once CMK type of encryption is enabled it won't be possible to switch back to default Microsoft Managed Encryption. | `bool`         | false                                                                                                                                                           |    no    |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id)                                                                             | Key Vault ID                                                                                                                                                                            | `string`       | null                                                                                                                                                            |    no    |
| <a name="input_key_vault_secret_permissions"></a> [key\_vault\_secret\_permissions](#input\_key\_vault\_secret\_permissions)                           | List of key vault secret permissions for Databricks Global Service Principal                                                                                                            | `list(string)` | <pre>[ <br> "Get",<br> "List"<br>]</pre>                                                                                                                        |    no    |
| <a name="input_key_vault_key_permissions"></a> [key\_vault\_key\_permissions](#input\_key\_vault\_key\_permissions)                                    | List of key vault key permissions for Databricks Global Service Principal                                                                                                               | `list(string)` | <pre>[<br>  "Get",<br>  "List",<br>  "Encrypt",<br>  "Decrypt",<br>  "WrapKey",<br>  "UnwrapKey",<br>  "GetRotationPolicy",<br>  "SetRotationPolicy"<br>]</pre> |    no    |
| <a name="input_key_vault_key_id"></a> [key\_vault\_key\_id](#input\_key\_vault\_key\_id)                                                               | Key Vault key IDs                                                                                                                                                                       | `string`       | null                                                                                                                                                            |    no    |
| <a name="input_global_databricks_object_id"></a> [global\_databricks\_object\_id](#input\_global\_databricks\_object\_id) | Global 'AzureDatabricks' SP object id | `string` | "9b38785a-6e08-4087-a0c4-20634343f21f"|    no    |
## Outputs

| Name                                                                                                                | Description                                   |
|---------------------------------------------------------------------------------------------------------------------|-----------------------------------------------|
| <a name="output_id"></a> [id](#output\_id)                                                                          | Azure Databricks Resource ID                  |
| <a name="output_workspace_url"></a> [workspace\_url](#output\_workspace\_url)                                       | Azure Databricks Workspace URL                |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id)                                          | Azure Databricks Workspace ID                 |
| <a name="output_sku"></a> [sku](#output\_sku)                                                                       | Azure Databricks Workspace SKU type           |
| <a name="output_access_connector_id"></a> [access\_connector\_id](#output\_access\_connector\_id)                   | Databricks Access Connector's Id              |
| <a name="output_access_connector_identity"></a> [access\_connector\_identity](#output\_access\_connector\_identity) | Databricks Access Connector's Identities list |
<!-- END_TF_DOCS -->

## License

Apache 2 Licensed. For more information please see [LICENSE](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/blob/main/LICENSE)
