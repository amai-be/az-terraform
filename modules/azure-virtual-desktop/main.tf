# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

locals {
    hp_prefix = "vdpool"
    ws_prefix = "vdws"
    ag_prefix = "vdag"
    rg_prefix = "rg"
}

resource "azurerm_resource_group" "rg_core" {
    name = join("-", [local.rg_prefix, "avd-core" ,var.workload ,var.environment])
    location = var.global_settings.location
}

resource "azurerm_resource_group" "rg_hosts" {
    name = join("-", [local.rg_prefix, "avd-hosts" ,var.workload ,var.environment])
    location = var.global_settings.location
}

resource "azurerm_virtual_desktop_host_pool" "vdpool" {
    location = var.global_settings.location
    resource_group_name = azurerm_resource_group.rg_core.name

    name = join("-", [local.hp_prefix, "avd" ,var.workload ,var.environment])
    friendly_name = var.environment == "prod" ? join(" ", ["Virtual Desktop", upper(var.workload)]) : join(" ", ["Virtual Desktop", upper(var.workload), var.environment])
    validate_environment = false
    start_vm_on_connect = try(var.start_vm_on_connect, false)
    type = try(var.type, "Pooled")
    load_balancer_type = var.type == "Personal" ? "Persistent" : var.load_balancer_type
    custom_rdp_properties = try(var.custom_rdp_properties, "drivestoredirect:s:;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:0;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:1;audiocapturemode:i:1")
    description = try(var.description, "This hostpool represents the ${var.workload} workload.")
    maximum_sessions_allowed = var.type == "Pooled" ? try(var.maximum_sessions_allowed, 8) : null
    personal_desktop_assignment_type = var.type == "Personal" ? try(var.personal_desktop_assignment_type, "Automatic") : null
}

resource "azurerm_virtual_desktop_application_group" "vdag_desktop" {
  name                = join("-", [local.ag_prefix, "avd" ,var.workload ,var.environment])
  location            = var.global_settings.location
  resource_group_name = azurerm_resource_group.rg_core.name

  type          = "Desktop"
  host_pool_id  = azurerm_virtual_desktop_host_pool.vdpool.id
  friendly_name = var.environment == "prod" ? join(" ", ["Virtual Desktop", upper(var.workload)]) : join(" ", ["Virtual Desktop", upper(var.workload), var.environment])
  description   = try(var.description, "This application group represents the ${var.workload} workload.")
}

resource "azurerm_virtual_desktop_workspace" "vdws" {
  name                = join("-", [local.ws_prefix, "avd" ,var.workload ,var.environment])
  location            = var.global_settings.location
  resource_group_name = azurerm_resource_group.rg_core.name

  friendly_name = var.environment == "prod" ? join(" ", ["Virtual Desktop", upper(var.workload)]) : join(" ", ["Virtual Desktop", upper(var.workload), var.environment])
  description   = try(var.description, "This workspace represents the ${var.workload} workload.")
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "vdws-vdag-assoc" {
  workspace_id         = azurerm_virtual_desktop_workspace.vdws.id
  application_group_id = azurerm_virtual_desktop_application_group.vdag_desktop.id
}