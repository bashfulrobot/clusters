
module "network" {
  source = "github.com/bashfulrobot/libvirt-module-network"

  kvm_subnet        = "10.10.0.0/24"
  kvm_subnet_prefix = "10.10.0"

  network_name = "darkstar"

}

module "vm" {
  source = "github.com/bashfulrobot/libvirt-module-vm"

  image_url              = "file:///var/lib/libvirt/images/jammy-server-cloudimg-amd64-disk-kvm.img"
  admin_name             = "dustin"
  admin_password_hash    = "$6$eSiMWLr1mDaOtUGX$9N3ExuWLeo3lqA4P7DFxrTB2fQIS/1rIAzXDmLn/IOPlXdJ.yiEUIP2xuGrodxeATCM5QOsC8PMjM2hI73uE91"
  path_to_ssh_public_key = "~/.ssh/id_ed25519.pub"

  host_prefix = "darkstar"
  host_suffix = "-overloard"
  vm_count    = 1

  network_domain    = module.network.network_domain
  network_id        = module.network.network_id
  kvm_subnet_prefix = "10.10.0"

  cluster_name = "darkstar"

  vm_vcpu         = 4
  vm_memory       = 8
  vm_os_disk_size = 100

  autostart = true

}

module "datavm" {
  source = "github.com/bashfulrobot/libvirt-module-datavm"

  image_url              = "file:///var/lib/libvirt/images/jammy-server-cloudimg-amd64-disk-kvm.img"
  admin_name             = "dustin"
  admin_password_hash    = "$6$eSiMWLr1mDaOtUGX$9N3ExuWLeo3lqA4P7DFxrTB2fQIS/1rIAzXDmLn/IOPlXdJ.yiEUIP2xuGrodxeATCM5QOsC8PMjM2hI73uE91"
  path_to_ssh_public_key = "~/.ssh/id_ed25519.pub"

  host_prefix = "darkstar"
  host_suffix = "-minion"
  vm_count    = 3

  network_domain    = module.network.network_domain
  network_id        = module.network.network_id
  kvm_subnet_prefix = "10.10.0"

  cluster_name = "darkstar"

  vm_vcpu           = 4
  vm_memory         = 8
  vm_os_disk_size   = 100
  vm_data_disk_size = 160

  autostart = true

}

# output "network_id" {
#   description = "ID of the created network"
#   # returned by my network module
#   value = module.network.network_id
# }
