packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.3.0"
    }
  }
}

variable "region" {
  type = string
}

source "amazon-ebs" "golden" {
  region        = var.region
  instance_type = "t3.micro"
  ssh_username  = "ubuntu"

  source_ami_filter {
    filters = {
      name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
    }
    owners      = ["099720109477"]
    most_recent = true
  }

  ami_name = "golden-ami-simple-{{timestamp}}"
}

build {
  sources = ["source.amazon-ebs.golden"]

  provisioner "shell" {
    script = "scripts/00_patch.sh"
  }

  provisioner "shell" {
    script = "scripts/10_install_nginx.sh"
  }

  post-processor "manifest" {
    output = "manifest.json"
  }
}
