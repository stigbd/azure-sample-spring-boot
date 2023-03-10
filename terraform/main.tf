terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.19.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

resource "random_string" "random" {
  length    = 5
  min_lower = 5
  special   = false
}

data "azuread_client_config" "current" {}

resource "random_uuid" "role-admin" {
}

resource "random_uuid" "role-user" {
}

# Configure the Azure Active Directory Provider
provider "azuread" {
}

# Configure an app
resource "azuread_application" "azure_sample_spring_boot" {
  display_name = "azure-sample-sprint-boot-${random_string.random.result}"

  owners           = [data.azuread_client_config.current.object_id]
  sign_in_audience = "AzureADMyOrg"

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All
      type = "Role"
    }

    resource_access {
      id   = "b4e74841-8e56-480b-be8b-910348b18b4c" # User.ReadWrite
      type = "Scope"
    }

    resource_access {
      id   = "06da0dbc-49e2-44d2-8312-53f166ab848a" # Directory.Read.All
      type = "Scope"
    }
  }

  app_role {
    allowed_member_types = ["User"]
    description          = "Full admin access"
    display_name         = "Admin"
    enabled              = true
    id                   = random_uuid.role-admin.result
    value                = "Admin"
  }

  app_role {
    allowed_member_types = ["User"]
    description          = "User rule"
    display_name         = "UserRule"
    enabled              = true
    id                   = random_uuid.role-user.result
    value                = "UserRule"
  }

  web {
    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = false
    }
    redirect_uris = ["http://localhost:8080/login/oauth2/code/"]
  }
}


resource "azuread_service_principal" "azure_sample_spring_boot" {
  application_id               = azuread_application.azure_sample_spring_boot.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "random_password" "password" {
  length  = 16
  special = true
}

# Create Service Principal password
resource "azuread_service_principal_password" "azure_sample_spring_boot" {
  end_date             = "2299-12-30T23:00:00Z" # Forever
  service_principal_id = azuread_service_principal.azure_sample_spring_boot.id
}

# Retrieve domain information
data "azuread_domains" "current" {
  only_initial = true
}

# Create a user
resource "azuread_user" "user" {
  user_principal_name = "user-${random_string.random.result}@${data.azuread_domains.current.domains.0.domain_name}"
  display_name        = "user-${random_string.random.result}"
  password            = random_password.password.result
}

resource "azuread_user" "admin" {
  user_principal_name = "admin-${random_string.random.result}@${data.azuread_domains.current.domains.0.domain_name}"
  display_name        = "admin-${random_string.random.result}"
  password            = random_password.password.result
}

resource "azuread_app_role_assignment" "admin" {
  app_role_id         = random_uuid.role-admin.result
  principal_object_id = azuread_user.admin.object_id
  resource_object_id  = azuread_service_principal.azure_sample_spring_boot.object_id
}

resource "azuread_app_role_assignment" "user" {
  app_role_id         = random_uuid.role-user.result
  principal_object_id = azuread_user.user.object_id
  resource_object_id  = azuread_service_principal.azure_sample_spring_boot.object_id
}
