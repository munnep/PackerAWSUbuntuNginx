variable "region" {
  type    = string
  default = "us-west-2"
}

packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntunginx" {
  ami_name      = "ubuntunginx"
  instance_type = "t2.micro"
  region        = "${var.region}"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name    = "ubuntunginx"
  sources = [
    "source.amazon-ebs.ubuntunginx",
  ]

  provisioner "shell" {
     inline = [
      "sleep 30",
      "echo updating system",
      "sudo apt-get update",
      "echo install nginx",
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]
  }
}