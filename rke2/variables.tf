#### User Variables

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

#### Cluster/Host Variables

variable "cluster_name" {
  description = "A name to provide for the k8s cluster"
  type        = string
  default     = "dk-cluster"
}
variable "host_prefix" {
  type    = string
  default = "k8svm"
}
variable "vm_host_suffix" {
  type    = string
  default = "-cp"
}
variable "datavm_host_suffix" {
  type    = string
  default = "-w"
}

#### Network Variables

variable "kvm_subnet" {
  type    = string
  default = "172.16.0.0/24"
}
variable "kvm_subnet_prefix" {
  type    = string
  default = "172.16.0"
}

#### VM Variables
variable "vm_vcpu" {
  description = "The number of virtual CPUs for the controller nodes"
  type        = number
  default     = 2
}
variable "vm_memory" {
  description = "The amount of memory in GB for the controller nodes"
  type        = number
  default     = 2
}
variable "vm_os_disk_size" {
  description = "The size of the OS disk in GB for the controller nodes"
  type        = number
  default     = 60
}
variable "vm_data_disk_size" {
  description = "The size of the data disk in GB for the controller nodes"
  type        = number
  default     = 100
}
variable "vm_count" {
  type    = number
  default = 1
  validation {
    condition     = var.vm_count >= 1
    error_message = "Must be 1 or more."
  }
}

#### Data VM Variables
variable "datavm_vcpu" {
  description = "The number of virtual CPUs for the worker nodes"
  type        = number
  default     = 2
}
variable "datavm_memory" {
  description = "The amount of memory in GB for the worker nodes"
  type        = number
  default     = 2
}
variable "datavm_os_disk_size" {
  description = "The size of the OS disk in GB for the worker nodes"
  type        = number
  default     = 60
}
variable "datavm_disk_size" {
  description = "The size of the data disk in GB for the worker nodes"
  type        = number
  default     = 100
}
variable "datavm_count" {
  type    = number
  default = 2
  validation {
    condition     = var.datavm_count >= 1
    error_message = "Must be 1 or more."
  }
}

#### Libvirt Variables
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
