variable "workspace_name" {
  type        = string
  description = "Databricks Workspace name"
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

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "sku" {
  type        = string
  description = "The sku to use for the Databricks Workspace: [standard|premium|trial]"
  default     = "premium"
}

variable "managed_resource_group_name" {
  type        = string
  description = "The name of the managed resource group"
  default     = null
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

variable "access_connector_name" {
  type        = string
  description = "Databricks Access Connector optional name"
  default     = null
}

variable "access_connector_enabled" {
  type        = bool
  description = "Provides an ability to provision Databricks Access Connector which is required for Unity Catalog feature"
  default     = true
}

variable "diagnostics_name" {
  type        = string
  description = "Diagnostic Settings optional name"
  default     = null
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

# Key Vault used for encryption
variable "key_vault_id" {
  type        = string
  description = "Key Vault ID"
  default     = null
}

variable "key_vault_secret_permissions" {
  type        = list(string)
  description = "List of key vault secret permissions for Databricks Global Service Principal"
  default     = ["Get", "List"]
}

variable "key_vault_key_permissions" {
  type        = list(string)
  description = "List of key vault key permissions for Databricks Global Service Principal"
  default = [
    "Get",
    "List",
    "Encrypt",
    "Decrypt",
    "WrapKey",
    "UnwrapKey",
    "GetRotationPolicy",
  ]
}

variable "global_databricks_object_id" {
  type        = string
  description = "Global 'AzureDatabricks' SP object id"
  default     = "9b38785a-6e08-4087-a0c4-20634343f21f"
}

# Managed Services Encryption
variable "managed_services_cmk_enabled" {
  type        = bool
  default     = false
  description = "Encrypts Databricks Workspaces Services like Notebooks and Queries, once CMK type of encryption is enabled it won't be possible to switch back to default Microsoft Managed Encryption."
}

variable "managed_services_cmk_key_vault_key_id" {
  type        = string
  description = "Key Vault key ID used for Databricks Managed Services encryption"
  default     = null
}

# Managed Disk Encryption
variable "managed_disk_cmk_enabled" {
  type        = bool
  description = "Boolean flag that determines whether Data Plane Disks are encrypted with CMK key"
  default     = false
}

variable "managed_disk_cmk_key_vault_key_id" {
  type        = string
  description = "Key Vault key ID used for Data Plane Disks encryption"
  default     = null
}

variable "managed_disk_cmk_policy_enabled" {
  type        = bool
  description = <<-DOC
  Create Key Vault Policy for Databricks Workspace Managed Disk identity.
  Upon initial creation of Workspace with Disk CMK encryption, Disk Encryption Set with managed identity is created, it is used for cluster's disks encryption.

  However, if Workspace already provisioned and have to updated to use Managed Disk encryption, then 'Disk Encryption Set' is known after creation.
  Which means, that you have to first apply with 'managed_disk_cmk_enabled = true' only and set 'managed_disk_cmk_policy_enabled' to false, because identity is unknown.
  On next apply, set 'managed_disk_cmk_policy_enabled' to true, because identity of Managed Disk is created and known.
  DOC
  default     = true
}

# DBFS Encryption
variable "managed_dbfs_cmk_enabled" {
  type        = bool
  description = "Boolean flag that determines whether Workspace DBFS is encrypted with CMK key"
  default     = false
}

variable "managed_storage_account_identity_enabled" {
  type        = bool
  description = "Prerequisite for DBFS encryption. Enabled managed Storage Account identity to create Key Vault Policy to access encryption keys"
  default     = true
}

variable "managed_dbfs_cmk_key_vault_key_id" {
  type        = string
  description = "Key Vault key ID used for Databricks DBFS encryption"
  default     = null
}

variable "storage_firewall_enabled" {
  type        = bool
  description = "Boolean flag that determines whether public access is disallowed"
  default     = true
}
