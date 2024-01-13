variable "admin_name" {
  type    = string
  default = "admin"
}

variable "admin_password_hash" {
  type = string
}

variable "path_to_ssh_public_key" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}
variable "host_prefix" {
  type    = string
  default = "k8svm"
}

variable "kvm_subnet" {
  type    = string
  default = "10.20.0.0/24"
}
variable "kvm_subnet_prefix" {
  type    = string
  default = "10.20.0"
}

variable "controller_count" {
  type    = number
  default = 1
  validation {
    condition     = var.controller_count >= 1
    error_message = "Must be 1 or more."
  }
}

variable "worker_count" {
  type    = number
  default = 2
  validation {
    condition     = var.worker_count >= 1
    error_message = "Must be 1 or more."
  }
}

variable "cluster_name" {
  description = "A name to provide for the k8s cluster"
  type        = string
  default     = "dk-cluster"
}

variable "controller_vcpu" {
  description = "The number of virtual CPUs for the controller nodes"
  type        = number
  default     = 2
}

variable "controller_memory" {
  description = "The amount of memory in GB for the controller nodes"
  type        = number
  default     = 2
}

variable "controller_os_disk_size" {
  description = "The size of the OS disk in GB for the controller nodes"
  type        = number
  default     = 60
}

variable "controller_data_disk_size" {
  description = "The size of the data disk in GB for the controller nodes"
  type        = number
  default     = 100
}

variable "worker_vcpu" {
  description = "The number of virtual CPUs for the worker nodes"
  type        = number
  default     = 2
}

variable "worker_memory" {
  description = "The amount of memory in GB for the worker nodes"
  type        = number
  default     = 2
}

variable "worker_os_disk_size" {
  description = "The size of the OS disk in GB for the worker nodes"
  type        = number
  default     = 60
}

variable "data_disk_size" {
  description = "The size of the data disk in GB for the worker nodes"
  type        = number
  default     = 100
}

variable "image_url" {
  description = "The URL of the image used to deploy the VMs"
  type        = string
  default     = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

variable "autostart" {
  description = "Whether to automatically start the VMs"
  type        = bool
  default     = false
}

variable "enable_qemu_agent" {
  description = "Whether to enable the qemu agent"
  type        = bool
  default     = false
}

variable "wait_for_lease" {
  description = "Whether to wait for the DHCP lease to be assigned"
  type        = bool
  default     = false
}
