packer {
  required_plugins {
    qemu = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

source "qemu" "ubuntu" {
  accelerator       = "kvm"

  iso_url           = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img"
  iso_checksum      = "sha256:4d602318cf14591ae9f8350582ce006a8e8f81014a682ac192c01994a50d2f83"
  output_directory  = "output-ubuntu"
  format            = "qcow2"
  memory            = 2048
  disk_size         = "20480"
  ssh_username      = "root"
  ssh_password      = "password"
  ssh_wait_timeout  = "30m"
  shutdown_command  = "sudo shutdown -P now"
  net_device        = "virtio-net"
  headless          = true

  http_directory    = "http"
  cd_files = ["./user-data", "./meta-data"]
  cd_label = "CIDATA"

  qemuargs = [
    ["-serial", "file:serial.log"]
  ]
}

build {
  name    = "ubuntu"
  sources = ["source.qemu.ubuntu"]

  provisioner "shell-local" {
    script = "machinefile.sh"
    environment_vars = [
      "TARGET=ubuntu",
      "SSH_HOST=${build.Host}",
      "SSH_PORT=${build.Port}"]
  }
}
