packer {
  required_plugins {
    docker = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = "ubuntu:jammy"
  commit = true
  changes = [
    "WORKDIR /app"
  ]
}

build {
  sources = ["source.docker.ubuntu"]

  provisioner "shell" {
    inline = [
      "apt-get update",
      "DEBIAN_FRONTEND=noninteractive apt-get install -y python3 python3-pip",
      "mkdir /app",
      "pip3 install flask"
    ]
  }

  post-processor "docker-tag" {
    repository = "ambiente-dev-python"
    tags       = ["v1"]
  }
}
