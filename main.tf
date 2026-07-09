# Genera un sufijo aleatorio para que el nombre del storage account
# nunca choque con uno ya existente.
resource "random_id" "suffix" {
  byte_length = 4
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "site" {
  name                     = "${var.storage_account_prefix}${random_id.suffix.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document = "index.html"
  }
}

# Sube el archivo index.html al contenedor especial $web
# que Azure crea automáticamente para sitios estáticos.
resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.site.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "${path.module}/site/index.html"

  # Se recalcula el hash para que Terraform detecte cambios
  # si queremos editar el index.html más adelante.
  content_md5 = filemd5("${path.module}/site/index.html")
}
