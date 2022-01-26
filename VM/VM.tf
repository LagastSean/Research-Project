#provider "azurerm" {
#  version = "~>2.0"
#  features {}
#}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.92.0"
    }
  }
}

provider "azurerm" {
   features {}
}

resource "azurerm_resource_group" "VMServer-RG" {
  count = var.Amount
  name     = "${element(var.Users_Name, count.index)}-VM"
  location = var.RG_Location
}

resource "azurerm_app_service_plan" "VMServer-SP" {
  count = var.Amount
  name                = var.SP_Name
  location            = azurerm_resource_group.VMServer-RG[count.index].location
  resource_group_name = azurerm_resource_group.VMServer-RG[count.index].name

  sku {
    tier              = var.SP_tier
    size              = var.SP_size
  }

  depends_on = [
    azurerm_resource_group.VMServer-RG,
  ]
}

resource "azurerm_app_service" "VMServer-AS0" {
  count               = var.Amount
  name                = "VMserver${var.Users_Name[count.index]}0"
  location            = azurerm_resource_group.VMServer-RG[count.index].location
  resource_group_name = azurerm_resource_group.VMServer-RG[count.index].name
  app_service_plan_id = azurerm_app_service_plan.VMServer-SP[count.index].id

  tags = {
    "Student" = "seanlagast"
  }

    source_control {
      repo_url           = var.AS_bootstrap
      branch             = var.AS_bootstrap_branch
      manual_integration = true
      use_mercurial      = false
  }

  depends_on = [
    azurerm_app_service_plan.VMServer-SP,
  ]
}

resource "azurerm_app_service" "VMServer-AS1" {
  count               = var.Amount
  name                = "VMserver${var.Users_Name[count.index]}1"
  location            = azurerm_resource_group.VMServer-RG[count.index].location
  resource_group_name = azurerm_resource_group.VMServer-RG[count.index].name
  app_service_plan_id = azurerm_app_service_plan.VMServer-SP[count.index].id

  tags = {
    "Student" = "seanlagast"
  }

    source_control {
      repo_url           = var.AS_bootstrap
      branch             = var.AS_bootstrap_branch
      manual_integration = true
      use_mercurial      = false
  }

  depends_on = [
    azurerm_app_service_plan.VMServer-SP,
  ]
}
#Werkt niet!
#resource "azuread_user" "UserId" {
#  count = 2
#  user_principal_name = var.Users_Email[count.index]
#  display_name        = var.Display_Name[count.index]
#}

#resource "azurerm_role_assignment" "example" {
#  count = 2
#  scope                = "/subscriptions/bc9fe0f4-4aa6-4e8a-859a-2909dc00af8e/resourceGroups/${azuread_user.UserId[count.index]}"
#  role_definition_name = "Contributor"
#  principal_id         = var.Users[count.index]
#}

resource "azurerm_role_assignment" "example" {
  count = var.Amount
  scope                = "/subscriptions/bc9fe0f4-4aa6-4e8a-859a-2909dc00af8e/resourceGroups/${var.Users_Name[count.index]}-VM"
  role_definition_name = "Contributor"
  principal_id         = var.Users_Id[count.index]

  depends_on = [
    azurerm_resource_group.VMServer-RG,
  ]
}