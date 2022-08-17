module "avd-environment" {
    source = "./modules/environment"
    for_each = local.avd.environments

    global_settings = local.global_settings

    workload = can(each.value.workload) ? each.value.workload : "office"
    environment = can(each.value.environment) ? each.value.environment : "prod"
    start_vm_on_connect = can(each.value.start_vm_on_connect) ? each.value.start_vm_on_connect : false
    type = can(each.value.type) ? each.value.type : "Pooled"
    load_balancer_type = can(each.value.load_balancer_type) ? each.value.load_balancer_type : "DepthFirst"
    custom_rdp_properties = can(each.value.custom_rdp_properties) ? each.value.custom_rdp_properties : "drivestoredirect:s:;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:0;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:1;audiocapturemode:i:1"
    description = can(each.value.description) ? each.value.description : "Test"
    personal_desktop_assignment_type = can(each.value.personal_desktop_assignment_type) ? each.value.personal_desktop_assignment_type : "Automatic"
    maximum_sessions_allowed = can(each.value.maximum_sessions_allowed) ? each.value.maximum_sessions_allowed : 8
}