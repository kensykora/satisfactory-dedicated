provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "shared"
    storage_account_name = "kmstf"
    container_name       = "tfstate"
    key                  = "satisfactory.tfstate"
  }
}

resource "azurerm_resource_group" "main" {
  name     = "satisfactory"
  location = "North Central US"
}

resource "random_pet" "suffix" {
}

resource "azurerm_storage_account" "main" {
  name                = "kmssatis${replace(random_pet.suffix.id, "-", "")}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  allow_blob_public_access = false

  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version = "TLS1_2"
}

resource "azurerm_storage_container" "backup" {
  storage_account_name = azurerm_storage_account.main.name
  name                 = "backup"
}
