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

#security group
resource "azurerm_network_security_group" "mtc-sg" {
  name                = "mtc-sg"
  location            = azurerm_resource_group.mtc-rg.location
  resource_group_name = azurerm_resource_group.mtc-rg.name

  tags = {
    enviroment = "dev"
  }
}

#security rule
resource "azurerm_network_security_rule" "mtc-dev-rule" {
  name                                = "mtc-dev-rule"
  priority                            = 100
  direction                           = "Inbound"
  access                              = "Allow"
  protocol                            = "*"
  source_port_range                   = "*"
  destination_port_range              = "*"
  source_address_prefix               = "*"
  destination_address_prefix           = "*"
  resource_group_name                 = azurerm_resource_group.mtc-rg.name
  network_security_group_name = azurerm_network_security_group.mtc-sg.name
}

#associate out security group with our sub-net