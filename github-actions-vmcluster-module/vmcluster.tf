resource "azurerm_network_interface" "netiface" {
  count               = local.instance_count
  name                = "${var.prefix}_netiface${count.index}"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  tags                = merge(var.tags, {})

  ip_configuration {
    name                          = "${var.prefix}_configuration"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine_extension" "customscript" {
  count                      = local.instance_count
  name                       = "${var.prefix}_customscript${count.index}"
  virtual_machine_id         = element(azurerm_windows_virtual_machine.vm.*.id, count.index)
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true
  tags                       = merge(var.tags, {})

  settings = <<-SETTINGS
    {
        "commandToExecute": "move %SYSTEMDRIVE%\\AzureData\\CustomData.bin %SYSTEMDRIVE%\\AzureData\\CustomData.ps1 && powershell.exe %SYSTEMDRIVE%\\AzureData\\CustomData.ps1 && del /f /q %SYSTEMDRIVE%\\AzureData\\CustomData.ps1 && exit 0"
    }
SETTINGS
}

resource "azurerm_windows_virtual_machine" "vm" {
  count                 = local.instance_count
  name                  = "${var.prefix}_vm${count.index}"
  location              = azurerm_resource_group.resource_group.location
  availability_set_id   = azurerm_availability_set.avset.id
  resource_group_name   = azurerm_resource_group.resource_group.name
  network_interface_ids = [element(azurerm_network_interface.netiface.*.id, count.index)]
  size                  = var.instance_type

  source_image_reference {
    publisher = var.os_image_spec.publisher
    offer     = var.os_image_spec.offer
    sku       = var.os_image_spec.sku
    version   = var.os_image_spec.version
  }

  os_disk {
    name                 = "${var.prefix}_osdisk${count.index}"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_in_gb
  }

  computer_name  = upper("${var.prefix}${format("%02d", count.index)}")
  admin_username = var.admin_username
  admin_password = var.admin_password
  custom_data    = base64encode(element(data.template_file.custom_data.*.rendered, count.index))

  tags = merge(var.tags, {})
}
