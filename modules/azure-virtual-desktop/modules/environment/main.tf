resource "azurerm_resource_group" "rg_core" {
    name = join("-", [var.prefix_list.rg_prefix, "avd-core" ,var.workload ,var.environment])
    location = var.global_settings.location
}

resource "azurerm_resource_group" "rg_hosts" {
    name = join("-", [var.prefix_list.rg_prefix, "avd-hosts" ,var.workload ,var.environment])
    location = var.global_settings.location
}

resource "azurerm_virtual_desktop_host_pool" "vdpool" {
    location = var.global_settings.location
    resource_group_name = azurerm_resource_group.rg_core.name

    name = join("-", [var.prefix_list.hp_prefix, "avd" ,var.workload ,var.environment])
    friendly_name = var.environment == "prod" ? join(" ", ["Virtual Desktop", upper(var.workload)]) : join(" ", ["Virtual Desktop", upper(var.workload), var.environment])
    validate_environment = false
    start_vm_on_connect = var.start_vm_on_connect
    type = var.type
    load_balancer_type = var.type == "Personal" ? "Persistent" : var.load_balancer_type
    custom_rdp_properties = var.custom_rdp_properties
    description = try(var.description, "This hostpool represents the ${var.workload} workload.")
    maximum_sessions_allowed = var.type == "Pooled" ? var.maximum_sessions_allowed : null
    personal_desktop_assignment_type = var.type == "Personal" ? var.personal_desktop_assignment_type : null
}

resource "azurerm_virtual_desktop_application_group" "vdag_desktop" {
  name                = join("-", [var.prefix_list.ag_prefix, "avd" ,var.workload ,var.environment])
  location            = var.global_settings.location
  resource_group_name = azurerm_resource_group.rg_core.name

  type          = "Desktop"
  host_pool_id  = azurerm_virtual_desktop_host_pool.vdpool.id
  friendly_name = var.environment == "prod" ? join(" ", ["Virtual Desktop", upper(var.workload)]) : join(" ", ["Virtual Desktop", upper(var.workload), var.environment])
  description   = try(var.description, "This application group represents the ${var.workload} workload.")
}

resource "azurerm_virtual_desktop_workspace" "vdws" {
  name                = join("-", [var.prefix_list.ws_prefix, "avd" ,var.workload ,var.environment])
  location            = var.global_settings.location
  resource_group_name = azurerm_resource_group.rg_core.name

  friendly_name = var.environment == "prod" ? join(" ", ["Virtual Desktop", upper(var.workload)]) : join(" ", ["Virtual Desktop", upper(var.workload), var.environment])
  description   = try(var.description, "This workspace represents the ${var.workload} workload.")
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "vdws-vdag-assoc" {
  workspace_id         = azurerm_virtual_desktop_workspace.vdws.id
  application_group_id = azurerm_virtual_desktop_application_group.vdag_desktop.id
}