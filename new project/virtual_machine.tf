resource "azurerm_linux_virtual_machine" "linux" {
  name                            = "noida-vm"
  location                        = azurerm_resource_group.noida_rg.location
  resource_group_name             = azurerm_resource_group.noida_rg.name
  size                            = "Standard_B1s"
  admin_username                  = "moneymul23"
  admin_password                  = "Hardwork#2026"
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nics.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"

  }

}