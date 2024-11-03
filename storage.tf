resource "azurerm_storage_account" "example" {
  name                     = "storsimple9898"
  resource_group_name      = data.azurerm_resource_group.RG-1.name
  location                 = data.azurerm_resource_group.RG-1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}