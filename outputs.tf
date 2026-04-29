output "app_public_ip" {
  value = data.azurerm_public_ip.pip.ip_address
}

output "mysql_fqdn" {
  value = azurerm_mysql_flexible_server.db.fqdn
}