output "web_app_name" {
  value = azurerm_linux_web_app.demo_web.name
}
output "web_app_url" {
  value = "https://${azurerm_linux_web_app.demo_web.default_hostname}"
}