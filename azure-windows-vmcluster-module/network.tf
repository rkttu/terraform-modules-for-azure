resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}_vnet"
  address_space       = var.address_spaces
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  tags                = merge(var.tags, {})
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}_subnet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_prefixes
}
