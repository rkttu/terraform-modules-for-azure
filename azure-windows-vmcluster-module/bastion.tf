resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "${var.prefix}_bastion_public_ip"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = merge(var.tags, {})
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = "${var.prefix}_bastion_host"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  tags                = merge(var.tags, {})

  ip_configuration {
    name                 = "${var.prefix}_bastion_configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_prefixes_bastion
}
