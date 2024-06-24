terraform {
  # cloud {
  #   organization = "bashfulrobot"

  #   workspaces {
  #     name = "darkmoon"
  #   }
  # }
  #   required_version = ">= 1.0.1"
  required_providers {
    # see https://registry.terraform.io/providers/dmacvicar/libvirt
    # see https://github.com/dmacvicar/terraform-provider-libvirt
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">= 0.7.6"
    }
  }
}
