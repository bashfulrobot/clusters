# see https://github.com/dmacvicar/terraform-provider-libvirt/blob/v0.7.1/website/docs/r/network.markdown
resource "libvirt_network" "cluster_net" {
  name      = var.network_name
  mode      = var.network_mode
  domain    = "${var.network_name}.test"
  addresses = [var.kvm_subnet]
  autostart = var.autostart_network
  dhcp {
    enabled = var.dhcp_enabled
  }
  dns {
    enabled    = var.dns_enabled
    local_only = var.dns_local_only
  }
}
