resource "azurerm_resource_group" "rg_network" {
    name = join("-", [var.prefix_list.rg_prefix, "avd", "network", "prod"])
    location = var.global_settings.location
}

resource "azurerm_virtual_network" "avd_spoke_vnet" {
    name = join("-", [var.prefix_list.vnet_prefix, "avd", "core", "001"])
    location = var.global_settings.location
    resource_group_name = azurerm_resource_group.rg_network.name
    address_space = [var.address_space]

    subnet{
        name = join("-", [var.prefix_list.snet_prefix, "avd", "infrastructure"])
        address_prefix = cidrsubnet("${var.address_space}", 4, 0)
    }

    subnet{
        name = join("-", [var.prefix_list.snet_prefix, "avd", "endpoints"])
        address_prefix = cidrsubnet("${var.address_space}", 4, 1)
    }
}

resource "azurerm_subnet" "avd_spoke_subnets" {
    count = length(var.environments)

    name = join("-", [var.prefix_list.snet_prefix, "avd", element(var.environments, count.index).workload, "hosts"])
    
    resource_group_name  = azurerm_resource_group.rg_network.name
    virtual_network_name = azurerm_virtual_network.avd_spoke_vnet.name

    address_prefixes = [cidrsubnet("${var.address_space}", 4, count.index + 2)]
}