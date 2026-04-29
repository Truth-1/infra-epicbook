# 1. REFERENCE EXISTING INFRASTRUCTURE
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = "epic-vnet"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "subnet" {
  name                 = "epic-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

# 2. PUBLIC IP (Using Standard SKU as required by newer Azure rules)
resource "azurerm_public_ip" "pip" {
  name                = "epic-ip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# 3. NETWORK INTERFACE
resource "azurerm_network_interface" "nic" {
  name                = "epic-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

# 4. VIRTUAL MACHINE
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "EpicBook-VM"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = "Standard_D2s_v3"
  admin_username      = var.vm_user
  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = var.vm_user
    public_key = file("~/.ssh/id_rsa.pub")
  }

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

# 5. MYSQL DATABASE 
resource "random_id" "id" {
  byte_length = 4
  keepers = {
    # Forces a new name if the state is lost, preventing "Already Exists" errors
    ami_id = 1 
  }
}

resource "random_password" "db_pass" {
  length  = 16
  special = true
}

resource "azurerm_mysql_flexible_server" "db" {
  name                   = "epicbook-db-${random_id.id.hex}"
  resource_group_name    = data.azurerm_resource_group.rg.name
  location               = data.azurerm_resource_group.rg.location
  administrator_login    = "dbadmin"
  administrator_password = random_password.db_pass.result
  sku_name               = "B_Standard_B1ms"
  version                = "8.0.21"
  zone                   = "1"
}

resource "azurerm_mysql_flexible_server_firewall_rule" "fw" {
  name                = "AllowAll"
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.db.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}