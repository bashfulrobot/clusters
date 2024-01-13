# instance the provider
provider "libvirt" {
  uri = "qemu:///system"
  # uri = "qemu+ssh://rembot/system"
  # uri = "qemu+ssh://dustin@100.89.186.70/system?keyfile=$HOME/.ssh/id_rsa_temp"
}
