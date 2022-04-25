terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.3.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tf_test" {
  name     = "tf_weatherApi"
  location = "West Europe"
}

resource "azurerm_container_group" "tfcg_test" {
  name                = "weatherapi"
  location            = azurerm_resource_group.tf_test.location
  resource_group_name = azurerm_resource_group.tf_test.name

  ip_address_type = "Public"
  dns_name_label  = "weatherapiv1to"
  os_type         = "Linux"

  container {
    name   = "weatherapi"
    image  = "v1to/weatherapi:96"
    cpu    = "1"
    memory = "1"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}