output "AZURE_TENANT_ID" {
  value       = data.azuread_client_config.current.tenant_id
  description = "The Azure tenant id."
}

output "AZURE_CLIENT_ID" {
  value       = azuread_application.azure_sample_spring_boot.application_id
  description = "The application id."
}

output "AZURE_APPLICATION_PASSWORD" {
  value       = azuread_application.azure_sample_spring_boot.object_id
  description = "The application password."
}

output "USER_NAME" {
  value       = azuread_user.user.user_principal_name
  description = "The user name of the user created by terraform."
}

output "USER_PASSWORD" {
  value       = azuread_user.user.password
  sensitive   = true
  description = "The password of the user created by terraform."
}

# Output the Service Principal and password
output "SERVICE_PRINCIPAL" {
  value     = azuread_service_principal.azure_sample_spring_boot.id
  sensitive = true
}

output "SERVICE_PRINCIPAL_PASSWORD" {
  value     = azuread_service_principal_password.azure_sample_spring_boot.value
  sensitive = true
}
