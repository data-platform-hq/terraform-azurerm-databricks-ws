# Azure Databricks Workspace Terraform module
Terraform module for creation Azure Databricks Workspace

## Usage
This module provides an ability to deploy Azure Databricks Workspace. Here is an example how to provision Azure Databricks Workspace in managed network with Databricks Access Connector

In this case, it is recommended to also provision prerequisite resources with [Resource Group](https://registry.terraform.io/modules/data-platform-hq/function-app-linux/azurerm/latest), [Network](https://registry.terraform.io/modules/data-platform-hq/network/azurerm/latest) and [Subnet](https://registry.terraform.io/modules/data-platform-hq/subnet/azurerm/latest) modules, otherwise provide required resources from your own sources. 

```hcl
locals {
  tags = {
    environment = "development"
  }
  log_analytics_map = { 
    (data.azurerm_log_analytics_workspace.example.name) = data.azurerm_log_analytics_workspace.example.id 
  }
}

data "azurerm_log_analytics_workspace" "example" {
  name                = "example-law"
  resource_group_name = "example-rg"
}

module "databricks-ws" {
  source  = "data-platform-hq/databricks-ws/azurerm"

  project                           = "datahq"
  env                               = "dev"
  location                          = "eastus"
  suffix                            = "example"
  tags                              = local.tags
  sku                               = "premium"
  resource_group                    = "example-rg"
  network_id                        = module.network.id
  public_subnet_name                = module.subnet_public.name
  private_subnet_name               = module.subnet_private.name
  public_subnet_nsg_association_id  = module.subnet_public.nsg_association_id
  private_subnet_nsg_association_id = module.subnet_private.nsg_association_id
  access_connector_enabled          = true
  log_analytics_workspace           = local.log_analytics_map
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                      | Version   |
| ------------------------------------------------------------------------- | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0  |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm)       | >= 3.40.0 |

## Providers

| Name                                                          | Version |
| ------------------------------------------------------------- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.40.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                                                    | Type     |
|---------------------------------------------------------------------------------------------------------------------------------------------------------| -------- |
| [azurerm_databricks_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace)               | resource |
| [azurerm_databricks_access_connector.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_access_connector) | resource |
| [data.azurerm_monitor_diagnostic_categories.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) | resource |
| [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting)   | resource |

## Inputs

| Name                                                                                                                                          | Description                                                                                                                                                                    | Type          | Default  | Required |
|-----------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|----------|:--------:|
| <a name="input_project"></a> [project](#input\_project)                                                                                       | Project name                                                                                                                                                                   | `string`      | n/a      |   yes    |
| <a name="input_env"></a> [env](#input\_env)                                                                                                   | Environment name                                                                                                                                                               | `string`      | n/a      |   yes    |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group)                                                                | The name of the resource group in which to create the storage account                                                                                                          | `string`      | n/a      |   yes    |
| <a name="input_location"></a> [location](#input\_location)                                                                                    | Azure location                                                                                                                                                                 | `string`      | n/a      |   yes    |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id)                                                                            | The ID of a Virtual Network where this Databricks Cluster should be created                                                                                                    | `string`      | n/a      |   yes    |
| <a name="input_public_subnet_name"></a> [public\_subnet\_name](#input\_public\_subnet\_name)                                                  | The name of the Public Subnet within the Virtual Network. Required if virtual_network_id is set                                                                                | `string`      | n/a      |   yes    |
| <a name="input_private_subnet_name"></a> [private\_subnet\_name](#input\_private\_subnet\_name)                                               | The name of the Private Subnet within the Virtual Network. Required if virtual_network_id is set                                                                               | `string`      | n/a      |   yes    |
| <a name="input_public_subnet_nsg_association_id"></a> [public\_subnet\_nsg\_association\_id](#input\_public\_subnet\_nsg\_association\_id)    | The resource ID of the azurerm_subnet_network_security_group_association resource which is referred to by the public_subnet_name field. Required if virtual_network_id is set  | `string`      | n/a      |   yes    |
| <a name="input_private_subnet_nsg_association_id"></a> [private\_subnet\_nsg\_association\_id](#input\_private\_subnet\_nsg\_association\_id) | The resource ID of the azurerm_subnet_network_security_group_association resource which is referred to by the private_subnet_name field. Required if virtual_network_id is set | `string`      | n/a      |   yes    |
| <a name="input_suffix"></a> [suffix](#input\_suffix)                                                                                          | Optional suffix that would be added to the end of resources names. It is recommended to use dash at the beginning of variable (e.x., '-example')                               | `string`      | n/a      |    no    |
| <a name="input_sku"></a> [sku](#input\_sku)                                                                                                   | The sku to use for the Databricks Workspace: <pre>[standard \premium \ trial]</pre>                                                                                            | `string`      | standard |    no    |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled)               | Allow public access for accessing workspace: <pre>[true \ false] </pre>                                                                                                        | `bool`        | true     |    no    |
| <a name="input_tags"></a> [tags](#input\_tags)                                                                                                | A mapping of tags to assign to the resource                                                                                                                                    | `map(string)` | {}       |    no    |
| <a name="input_no_public_ip"></a> [no\_public\_ip](#input\_no\_public\_ip)                                                                    | Are public IP Addresses not allowed?: <pre>[true \ false] </pre>                                                                                                               | `bool`        | true     |    no    |
| <a name="input_nsg_rules_required"></a> [nsg\_rules\_required](#input\_nsg\_rules\_required)                                                  | Does the data plane to control plane communication happen over private link endpoint only or publicly?: <pre>[AllRules \ NoAzureDatabricksRules \ NoAzureServiceRules] </pre>  | `string`      | AllRules |    no    |
| <a name="input_access_connector_enabled"></a> [access\_connector\_enabled](#input\_access\_connector\_enabled)                                | Provides an ability to provision Databricks Access Connector which is required for Unity Catalog feature                                                                       | `bool`        | false    |    no    |
| <a name="input_log_analytics_workspace"></a> [log\_analytics\_workspace](#input\_log\_analytics\_workspace)| Log Analytics Workspace Name to ID map | `map(string)` | {} | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days)| Retention policy days. Setting this to 0 will retain the events indefinitely | `number` | 0 | no |
| <a name="input_analytics_destination_type"></a> [analytics\_destination\_type](#input\_analytics\_destination\_type)| Log analytics destination type | `string` | "Dedicated" | no |

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
