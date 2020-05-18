output "windows-server-1909-containers-smalldisk-latest" {
  value = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "datacenter-core-1909-with-containers-smalldisk"
    version   = "latest"
  }
}
