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

#state (!IMPORTANT!) - We have terraform.tfstate that has all the resources created
#                    - We also have terraform.tfstate.backup if you we destroy by mistake, just rename it.

#subnet
resource "azurerm_subnet" "mtc-subnet" {
  name                 = "mtc-subnet"
  resource_group_name  = azurerm_resource_group.mtc-rg.name
  virtual_network_name = azurerm_virtual_network.mtc-vn.name
  address_prefixes     = ["10.123.1.0/24"]
}

#security rules
resource "azurerm_network_security_rule" "mtc-sg" {
  name                = "mtc-sg"
  location            = azurerm_resource_group.mtc-rg.location
  resource_group_name = azurerm_resource_group.mtc-rg.name

  tags = {
    enviroment = "dev"
  }
}
