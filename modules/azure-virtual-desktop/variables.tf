variable "workload" {
  type = string
  default = null
}

variable "environment" {
  type = string
  default = null
}

variable "start_vm_on_connect" {
  type = bool
  default = null
}

variable "type" {
  type = string
  default = null
}

variable "load_balancer_type" {
  type = string
  default = null
}

variable "custom_rdp_properties" {
  type = string
  default = null
}

variable "description" {
  type = string
  default = null
}

variable "personal_desktop_assignment_type" {
  type = string
  default = null
}
variable "maximum_sessions_allowed" {
  type = number
  default = null
}

variable "global_settings" {
  default = {
    location = "westeurope"
  }
}