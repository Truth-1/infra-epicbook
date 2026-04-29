output "app_public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "mysql_fqdn" {
  value = "your-db-host-here" # Replace with actual DB output if using PaaS
}