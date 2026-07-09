variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
  default     = "rg-terraform-demo-g3"
}

variable "location" {
  description = "Región de Azure donde se crean los recursos"
  type        = string
  default     = "eastus"
}

variable "storage_account_prefix" {
  description = "Prefijo del storage account (el sufijo único se genera solo)"
  type        = string
  default     = "sttfdemog3"
}
