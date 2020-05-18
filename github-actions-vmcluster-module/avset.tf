resource "azurerm_availability_set" "avset" {
  name                         = "${var.prefix}_avset"
  location                     = azurerm_resource_group.resource_group.location
  resource_group_name          = azurerm_resource_group.resource_group.name
  platform_fault_domain_count  = max(min(local.instance_count, 2), 1)
  platform_update_domain_count = max(min(local.instance_count, 20), 1)
  managed                      = true
  tags                         = merge(var.tags, {})
}
