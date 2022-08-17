locals {
  global_settings = try(var.global_settings, {})

  avd = {
    environments = try(var.avd.environments, {})
    maintenance = try(var.avd.maintenance, {})
    image = try(var.avd.image, {})
    network = try(var.avd.network, {})
    storage = try(var.avd.storage, {})
  }
}