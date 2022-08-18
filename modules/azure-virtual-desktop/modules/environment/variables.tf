variable "workload" {
  type = string
  default = "standard"
}

variable "environment" {
  type = string
  default = "dev"
}

variable "start_vm_on_connect" {
  type = bool
  default = false
}

variable "type" {
  type = string
  default = "Pooled"
}

variable "load_balancer_type" {
  type = string
  default = "DepthFirst"
}

variable "custom_rdp_properties" {
  type = string
  default = "drivestoredirect:s:;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:0;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:1;audiocapturemode:i:1"
}

variable "description" {
  type = string
  default = "Standard description"
}

variable "personal_desktop_assignment_type" {
  type = string
  default = "Automatic"
}
variable "maximum_sessions_allowed" {
  type = number
  default = 8
}

variable "global_settings" {
  default = {
    location = "westeurope"
  }
}

variable "prefix_list" {
  default = {}
}