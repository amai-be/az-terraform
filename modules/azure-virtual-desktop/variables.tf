variable "global_settings" {
    description = "Configuration object - Global Settings"
    default = {}
}

variable "prefix_list" {
    description = "Configuration object - Global Settings"
    default = {
        hp_prefix = "vdpool"
        ws_prefix = "vdws"
        ag_prefix = "vdag"
        rg_prefix = "rg"
        vnet_prefix = "vnet"
        snet_prefix = "snet"
    }
}

variable "avd" {
    description = "Configuration object - Azure Virtual Desktop resources"
    default = {}
}