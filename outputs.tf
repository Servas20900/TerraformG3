output "storage_account_name" {
  description = "Nombre generado del storage account"
  value       = azurerm_storage_account.site.name
}

output "website_url" {
  description = "URL pública del sitio estático"
  value       = azurerm_storage_account.site.primary_web_endpoint
}
