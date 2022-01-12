provider "azurerm" {
  version = "~>2.0"
  features {}
}

resource "azurerm_resource_group" "WebServer-RG" {
  count = 2
  name     = element(var.RG_Name, count.index)
  location = var.RG_Location
}

resource "azurerm_app_service_plan" "WebServer-SP" {
  count = 2
  name                = var.SP_Name
  location            = azurerm_resource_group.WebServer-RG[count.index].location
  resource_group_name = azurerm_resource_group.WebServer-RG[count.index].name

  sku {
    tier              = var.SP_tier
    size              = var.SP_size
  }
}

resource "azurerm_app_service" "WebServer-AS0" {
  count               = 2
  name                = "Webserver-${var.User_Name[count.index]}-0"
  location            = azurerm_resource_group.WebServer-RG[count.index].location
  resource_group_name = azurerm_resource_group.WebServer-RG[count.index].name
  app_service_plan_id = azurerm_app_service_plan.WebServer-SP[count.index].id

  tags = {
    "Student" = "seanlagast"
  }

    source_control {
      repo_url           = var.AS_bootstrap
      branch             = var.AS_bootstrap_branch
      manual_integration = true
      use_mercurial      = false
  }
}

resource "azurerm_app_service" "WebServer-AS1" {
  count               = 2
  name                = "Webserver-${var.User_Name[count.index]}-1"
  location            = azurerm_resource_group.WebServer-RG[count.index].location
  resource_group_name = azurerm_resource_group.WebServer-RG[count.index].name
  app_service_plan_id = azurerm_app_service_plan.WebServer-SP[count.index].id

  tags = {
    "Student" = "seanlagast"
  }

    source_control {
      repo_url           = var.AS_bootstrap
      branch             = var.AS_bootstrap_branch
      manual_integration = true
      use_mercurial      = false
  }
}