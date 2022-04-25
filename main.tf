terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.3.0"
    }
  }

  backend "azurerm" {
    resource_group_name = "Infra_rg"
    storage_account_name = "tfstatestoragev1to"
    container_name = "tfstate"
    key = "terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

variable "imageBuildId" {
  type = string
  description = "Latest build Id of docker image."
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
    image  = "v1to/weatherapi:${var.imageBuildId}"
    cpu    = "1"
    memory = "1"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}