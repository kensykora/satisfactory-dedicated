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

resource "azurerm_storage_management_policy" "expire_backups" {
  storage_account_id = azurerm_storage_account.main.id

  rule {
    name    = "ExpireAfter14Days"
    enabled = true
    filters {
      prefix_match = ["*"]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = 14
      }
      snapshot {
        delete_after_days_since_creation_greater_than = 14
      }
      version {
        delete_after_days_since_creation = 14
      }
    }
  }
}
