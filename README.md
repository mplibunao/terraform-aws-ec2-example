# What this module does

Terraform Module to provision an EC2 Instance with Security Group with ingress rules for HTTP, HTTPS, and ICMP

Not intended for production use. Just showcasing how to create a custom module on Terraform Registry

# Example

```hcl
# main.tf
terraform {

}

module "ec2" {
  source        = "./modules/terraform-aws-ec2"
  instance_type = "t2.nano"
  ami_type      = "ec2"
  instance_name = "MP-instance"
  ssh_pub_key   = var.ssh_pub_key
  ingress_rules = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    },
    {
      description      = "HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    },
    {
      description      = "Ping"
      from_port        = 8
      to_port          = 0
      protocol         = "icmp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    }
  ]
}

# providers.tf
locals {
  profile = var.pipeline ? "" : "default"
}

provider "aws" {
  region  = "ap-southeast-1"
  profile = local.profile
}

# variables.tf
variable "pipeline" {
  type        = bool
  default     = false
  description = "Whether operation is being run in a pipeline"
}

variable "ssh_pub_key" {
  type        = string
  description = "SSH public key for the ec2 instance"
}
```
