output "network_id" {
  description = "ID of libvirt network"
  value       = libvirt_network.cluster_net.id
}

output "network_domain" {
  description = "Domain of libvirt network"
  value       = libvirt_network.cluster_net.domain
}
