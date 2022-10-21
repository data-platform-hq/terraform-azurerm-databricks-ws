# Azure Databricks Workspace Terraform module
Terraform module for creation Azure Databricks Workspace

## Usage

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                      | Version   |
| ------------------------------------------------------------------------- | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0  |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm)       | >= 3.23.0 |

## Providers

| Name                                                          | Version |
| ------------------------------------------------------------- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.24.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                                      | Type     |
| ----------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [azurerm_databricks_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace) | resource |

## Inputs

| Name                                                                                                                                          | Description                                                                                                                                                                    | Type          | Default  | Required |
| --------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------- | -------- | :------: |
| <a name="input_project"></a> [project](#input\_project)                                                                                       | Project name                                                                                                                                                                   | `string`      | n/a      |   yes    |
| <a name="input_env"></a> [env](#input\_env)                                                                                                   | Environment name                                                                                                                                                               | `string`      | n/a      |   yes    |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group)                                                                | The name of the resource group in which to create the storage account                                                                                                          | `string`      | n/a      |   yes    |
| <a name="input_location"></a> [location](#input\_location)                                                                                    | Azure location                                                                                                                                                                 | `string`      | n/a      |   yes    |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id)                                                                            | The ID of a Virtual Network where this Databricks Cluster should be created                                                                                                    | `string`      | n/a      |   yes    |
| <a name="input_public_subnet_name"></a> [public\_subnet\_name](#input\_public\_subnet\_name)                                                  | The name of the Public Subnet within the Virtual Network. Required if virtual_network_id is set                                                                                | `string`      | n/a      |   yes    |
| <a name="input_private_subnet_name"></a> [private\_subnet\_name](#input\_private\_subnet\_name)                                               | The name of the Private Subnet within the Virtual Network. Required if virtual_network_id is set                                                                               | `string`      | n/a      |   yes    |
| <a name="input_public_subnet_nsg_association_id"></a> [public\_subnet\_nsg\_association\_id](#input\_public\_subnet\_nsg\_association\_id)    | The resource ID of the azurerm_subnet_network_security_group_association resource which is referred to by the public_subnet_name field. Required if virtual_network_id is set  | `string`      | n/a      |   yes    |
| <a name="input_private_subnet_nsg_association_id"></a> [private\_subnet\_nsg\_association\_id](#input\_private\_subnet\_nsg\_association\_id) | The resource ID of the azurerm_subnet_network_security_group_association resource which is referred to by the private_subnet_name field. Required if virtual_network_id is set | `string`      | n/a      |   yes    |
| <a name="input_sku"></a> [sku](#input\_sku)                                                                                                   | The sku to use for the Databricks Workspace: [standard \| premium \| trial]                                                                                                    | `string`      | standard |    no    |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled)               | Allow public access for accessing workspace: [true \| false]                                                                                                                   | `bool`        | true     |    no    |
| <a name="input_tags"></a> [tags](#input\_tags)                                                                                                | A mapping of tags to assign to the resource                                                                                                                                    | `map(string)` | {}       |    no    |
| <a name="input_no_public_ip"></a> [no\_public\_ip](#input\_no\_public\_ip)                                                                    | Are public IP Addresses not allowed?: [true \| false]                                                                                                                          | `bool`        | true     |    no    |
| <a name="input_nsg_rules_required"></a> [nsg\_rules\_required](#input\_nsg\_rules\_required)                                                  | Does the data plane to control plane communication happen over private link endpoint only or publicly?: [AllRules, NoAzureDatabricksRules, NoAzureServiceRules]                | `string`      | AllRules |    no    |

## Outputs

| Name                                                                          | Description                         |
| ----------------------------------------------------------------------------- | ----------------------------------- |
| <a name="output_id"></a> [id](#output\_id)                                    | Azure Databricks Resource ID        |
| <a name="output_workspace_url"></a> [workspace\_url](#output\_workspace\_url) | Azure Databricks Workspace URL      |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id)    | Azure Databricks Workspace ID       |
| <a name="output_sku"></a> [sku](#output\_sku)                                 | Azure Databricks Workspace SKU type |
<!-- END_TF_DOCS -->

## License

Apache 2 Licensed. For more information please see [LICENSE](https://github.com/data-platform-hq/terraform-azurerm-databricks-ws/blob/main/LICENSE)
