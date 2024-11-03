data "azurerm_resource_group" "RG-1" {
  name = "learn-d7810094-c1d2-4248-912d-2e6b54eaec44"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "dev-nsg001"
  location            = data.azurerm_resource_group.RG-1.location
  resource_group_name = data.azurerm_resource_group.RG-1.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "dev-vnet001"
  location            = data.azurerm_resource_group.RG-1.location
  resource_group_name = data.azurerm_resource_group.RG-1.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = data.azurerm_resource_group.RG-1.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}


resource "azurerm_network_interface" "interface-nic" {
  name                = "dev-vm-nic"
  location            = data.azurerm_resource_group.RG-1.location
  resource_group_name = data.azurerm_resource_group.RG-1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}


#Virtual machine code

resource "azurerm_windows_virtual_machine" "dev-vm" {
  name                = "dev-machine"
  resource_group_name = data.azurerm_resource_group.RG-1.name
  location            = data.azurerm_resource_group.RG-1.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.interface-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-windows-server-eval-core"

    version = "latest"
  }

  priority        = "Spot"
  eviction_policy = "Deallocate"
  max_bid_price   = 0.20
}