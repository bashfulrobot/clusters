# instance the provider
provider "libvirt" {
  # uri = "qemu+ssh://srv-ts/system"
  # uri = "qemu+ssh://dustin@100.123.211.36/system?keyfile=/home/dustin/.ssh/id_ed25519_np"
  # uri = "qemu+ssh://dustin@100.123.211.36/system?keyfile=/home/dustin/.ssh/id_ed25519_np&sshauth=privkey"
  uri = "qemu:///system"
  # uri = "qemu+ssh://rembot/system"
  # uri = "qemu+ssh://dustin@100.89.186.70/system?keyfile=$HOME/.ssh/id_rsa_temp"
}
