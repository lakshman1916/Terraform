provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "RG" {
  name     = "git-jenkins-rg"
  location = "north central us"
}

resource "azurerm_service_plan" "ASP" {
  name                = "git-jenkins-ASP"
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  sku_name            = "F1"
  os_type             = "Windows"
}

resource "azurerm_windows_web_app" "webapp" {
  name                = "git-jenkins-Webapp"
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_service_plan.ASP.location
  service_plan_id     = azurerm_service_plan.ASP.id

  site_config {}
}
