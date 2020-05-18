resource "azurerm_public_ip" "public_ip" {
  name                = "${var.prefix}_lb_public_ip"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = var.public_ip_allocation_method
  tags                = merge(var.tags, {})
}

resource "azurerm_lb" "lb" {
  name                = "${var.prefix}_lb"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  tags                = merge(var.tags, {})

  frontend_ip_configuration {
    name                 = "${var.prefix}_lb_frontend_ipcfg"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "addrpool" {
  resource_group_name = azurerm_resource_group.resource_group.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "${var.prefix}_lb_backend_addrpool"
}
