variable "kvm_subnet" {
  type    = string
  default = "10.20.0.0/24"
}
variable "kvm_subnet_prefix" {
  type    = string
  default = "10.20.0"
}

variable "network_name" {
  description = "A name to provide for the k8s cluster network"
  type        = string
  default     = "deault"
}

variable "dhcp_enabled" {
  description = "Enable DHCP for the k8s cluster network"
  type        = bool
  default     = false
}

variable "dns_enabled" {
  description = "Enable DNS for the k8s cluster network"
  type        = bool
  default     = true
}

variable "dns_local_only" {
  description = "Enable local only DNS for the k8s cluster network"
  type        = bool
  default     = false
}

variable "autostart_network" {
  description = "Autostart the k8s cluster network"
  type        = bool
  default     = true
}

variable "network_mode" {
  description = "The network mode for the k8s cluster network"
  type        = string
  default     = "nat"
}
