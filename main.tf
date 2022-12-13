terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.97.0"
    }
  }
}

provider "azurerm" {
  features {}
}

#create a user group - these need to be created to group all my enviroment inside 
resource "azurerm_resource_group" "mtc-rg" {
  name     = "mtc-resources"
  location = "ukwest"
  tags = {
    enviroment = "dev"
  }
}

#virtual network
resource "azurerm_virtual_network" "mtc-vn" {
  name                = "mtc-network"
  resource_group_name = azurerm_resource_group.mtc-rg.name #referecing is important
  location            = azurerm_resource_group.mtc-rg.location
  address_space       = ["10.123.0.0/16"]

  tags = {
    enviroment = "dev"
  }
}




