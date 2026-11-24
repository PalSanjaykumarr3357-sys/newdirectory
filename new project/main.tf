terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"

    }
  }
}
provider "azurerm" {
  features {}
}

locals {
  project     = "payments"
  env         = "dev"
  location    = "eastus"
  subnet      = "${local.prefix}-frontend"
  prefix      = "${local.project}-${local.env}"
  rg_name     = "${local.prefix}-rg"
  vnet_name   = "${local.prefix}-vnet"
  subnet_name = "${local.prefix}-subnet"
  nic_name    = "${local.prefix}-nic"
  #vnet_cidr   = ["10.0.0.0/16"]
  subnet_cidr   = "10.0.1.0/24"
  address_space = "10.0.0.0/16"
  dns_servers   = "10.0.0.10"


  tags = {
    project = local.project
    env     = local.env
  }

}

resource "azurerm_resource_group" "noida_rg" {
  name     = local.rg_name
  location = local.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "vnet_name" {
  name                = local.vnet_name
  location            = azurerm_resource_group.noida_rg.location
  resource_group_name = azurerm_resource_group.noida_rg.name
  address_space       = [local.address_space]
  #dns_servers         = ["10.0.0.10"]


}

resource "azurerm_subnet" "subnets" {

  name                 = local.subnet
  resource_group_name  = azurerm_resource_group.noida_rg.name
  virtual_network_name = azurerm_virtual_network.vnet_name.name
  address_prefixes     = [local.subnet_cidr]

}

resource "azurerm_network_interface" "nics" {
  name                = local.nic_name
  location            = local.location
  resource_group_name = azurerm_resource_group.noida_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets.id
    private_ip_address_allocation = "dynamic"
  }
}

