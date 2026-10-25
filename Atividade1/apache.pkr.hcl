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
    "EXPOSE 80",
    "CMD [\"apachectl\", \"-D\", \"FOREGROUND\"]"
  ]
}

build {
  sources = ["source.docker.ubuntu"]

  provisioner "shell" {
    inline = [
      "apt-get update",
      "DEBIAN_FRONTEND=noninteractive apt-get install -y apache2"
    ]
  }

  provisioner "file" {
    source      = "index.html"
    destination = "/var/www/html/index.html"
  }

  post-processor "docker-tag" {
    repository = "meu-apache-packer"
    tags       = ["latest"]
  }
}
