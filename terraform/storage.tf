resource "azurerm_storage_account" "demo_web_storage" {
  name                     = "stsdddemo${random_integer.suffix.result}"
  resource_group_name      = azurerm_resource_group.instance.name
  location                 = azurerm_resource_group.instance.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "demo_web_container" {
  name                  = "demo-web-container"
  storage_account_name  = azurerm_storage_account.demo_web_storage.name
  container_access_type = "private"
}

resource "azurerm_key_vault_secret" "demo_web_storage_connection_string" {
  name         = "StorageConnection"
  key_vault_id = data.azurerm_key_vault.shared.id
  value        = azurerm_storage_account.demo_web_storage.primary_blob_connection_string
}