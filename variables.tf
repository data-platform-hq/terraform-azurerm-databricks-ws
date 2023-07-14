variable "project" {
  type        = string
  description = "Project name"
}

variable "env" {
  type        = string
  description = "Environment name"
}

variable "resource_group" {
  type        = string
  description = "The name of the resource group in which to create the storage account"
}

variable "location" {
  type        = string
  description = "Azure location"
}


variable "network_id" {
  type        = string
  description = "The ID of a Virtual Network where this Databricks Cluster should be created"
}

variable "public_subnet_name" {
  type        = string
  description = "The name of the Public Subnet within the Virtual Network. Required if virtual_network_id is set"
}

variable "private_subnet_name" {
  type        = string
  description = "The name of the Private Subnet within the Virtual Network. Required if virtual_network_id is set"
}

variable "public_subnet_nsg_association_id" {
  type        = string
  description = "The resource ID of the azurerm_subnet_network_security_group_association resource which is referred to by the public_subnet_name field. Required if virtual_network_id is set"
}

variable "private_subnet_nsg_association_id" {
  type        = string
  description = "The resource ID of the azurerm_subnet_network_security_group_association resource which is referred to by the private_subnet_name field. Required if virtual_network_id is set"
}

variable "custom_workspace_name" {
  type        = string
  description = "Specifies the name of the Databricks Workspace resource"
  default     = null
}

variable "custom_access_connector_name" {
  type        = string
  description = "Specifies the name of the Databricks Access Connector resource"
  default     = null
}

variable "custom_diagnostics_name" {
  type        = string
  description = "Custom name for Diagnostic Settings that monitors Databricks Workspace"
  default     = null
}

variable "custom_cmk_services_name" {
  type        = string
  description = "Specifies the name of the Key Vault Key for Databricks Services CMK encryption"
  default     = null
}

variable "suffix" {
  type        = string
  description = "Optional suffix that would be added to the end of resources names. It is recommended to use dash at the beginning of variable (e.x., '-example')"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "sku" {
  type        = string
  description = "The sku to use for the Databricks Workspace: [standard|premium|trial]"
  default     = "standard"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Allow public access for accessing workspace: [true|false]"
  default     = true
}

variable "no_public_ip" {
  type        = bool
  description = "Are public IP Addresses not allowed?: [true|false]"
  default     = true
}

variable "nsg_rules_required" {
  type        = string
  description = "Does the data plane to control plane communication happen over private link endpoint only or publicly?: [AllRules, NoAzureDatabricksRules, NoAzureServiceRules]"
  default     = "AllRules"
}

variable "access_connector_enabled" {
  type        = bool
  description = "Provides an ability to provision Databricks Access Connector which is required for Unity Catalog feature"
  default     = false
}

variable "log_analytics_workspace" {
  type        = map(string)
  description = "Log Analytics Workspace Name to ID map"
  default     = {}
}

variable "analytics_destination_type" {
  type        = string
  default     = "Dedicated"
  description = "Log analytics destination type"
}

variable "key_vault_id" {
  type        = string
  description = "Key Vault ID"
  default     = null
}

variable "key_permissions" {
  type        = list(string)
  description = "List of key vault key permissions"
  default = [
    "Get",
    "List",
    "Encrypt",
    "Decrypt",
    "WrapKey",
    "UnwrapKey",
    "GetRotationPolicy",
    "SetRotationPolicy",
  ]
}

variable "customer_managed_service_key_enabled" {
  type        = bool
  default     = false
  description = <<-EOT
  Enabling Service Encryption with Customer Managed Key on already existing Databricks Workspace triggers its replacement. Currently Databricks Terraform Provider wil fail in this case, that's why you have to:
  1. de-provision all resources created with Databricks Provider, 
  2. enable Encryption with setting 'customer_managed_service_key_enabled' to true,
  3. Ensure that Purge protection for key vault is enabled
  4. provision Databricks Resources with it's Provider (clusters, secret scope, notebook, etc.)
  EOT
}

variable "key_vault_key_map" {
  type        = map(string)
  description = "A map of Key Vault key names to Key Vault key IDs"
  default     = {}
}

variable "global_databricks_object_id" {
  type        = string
  description = "Global 'AzureDatabricks' SP object id"
  default     = "9b38785a-6e08-4087-a0c4-20634343f21f"
}
