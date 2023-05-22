output "public_ip_address" {
  description = "IP address allocated for the resource."
  value       = "${azurerm_public_ip.k3s.ip_address}"
}

output "public_ip_dns_name" {
  description = "FQND to connect to the VM provisioned."
  value       = "${azurerm_public_ip.k3s.fqdn}"
}