terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.6.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "instance" {
  name     = "sdd-demo"
  location = "West Europe"
}

data "azurerm_service_plan" "shared" {
  name                = "plan-demo"
  resource_group_name = "rg-shared-demo"
}

data "azurerm_key_vault" "shared" {
  name                = "kv-demo-1421"
  resource_group_name = "rg-shared-demo"
}

locals {
  suffix = "demo"
  prefix = "sdd"
}

locals {
  suffix2 = "demo2"
}

resource "azurerm_linux_web_app" "demo_web" {
  name                = "app-sdd-${local.suffix}"
  resource_group_name = azurerm_resource_group.instance.name
  location            = azurerm_resource_group.instance.location
  service_plan_id     = data.azurerm_service_plan.shared.id

  identity {
    type = "SystemAssigned"
  }

  site_config {}
}

resource "azurerm_key_vault_access_policy" "demo_web_access" {
  key_vault_id = data.azurerm_key_vault.shared.id
  object_id    = azurerm_linux_web_app.demo_web.identity.0.principal_id
  tenant_id    = azurerm_linux_web_app.demo_web.identity.0.tenant_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_linux_web_app_slot" "demo_web_slot" {
  count = var.slot_count
  name           = "slot-sdd-demo-${count.index}"
  app_service_id = azurerm_linux_web_app.demo_web.id

  identity {
    type = "SystemAssigned"
  }

  site_config {}
}

resource "azurerm_key_vault_access_policy" "demo_web_slot_access" {
  count = var.slot_count
  key_vault_id = data.azurerm_key_vault.shared.id
  object_id    = azurerm_linux_web_app_slot.demo_web_slot[count.index].identity.0.principal_id
  tenant_id    = azurerm_linux_web_app_slot.demo_web_slot[count.index].identity.0.tenant_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "random_integer" "suffix" {
  min = 1
  max = 99
}


