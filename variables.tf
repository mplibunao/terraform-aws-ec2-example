
variable "ami_type" {
  type        = string
  default     = "ec2"
  description = "Will determine the ami id for the instance. Choose between ec2, ecs"
  validation {
    condition     = contains(["ec2", "ecs", "ubuntu"], var.ami_type)
    error_message = "Select either ec2, ecs, ubuntu"
  }
}

variable "instance_type" {
  type        = string
  description = "AWS EC2 Instance type or size of instance"
  validation {
    condition     = can(regex("^t2.", var.instance_type))
    error_message = "Instance must be a t2 type EC2 instance"
  }
}

variable "ingress_rules" {
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
  description = "ingress rule configurations"
  default     = []
}

variable "egress_rules" {
  type = list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
  description = "egress rule configurations"
  default = [{
    description      = "outgoing traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }]
}

variable "ssh_pub_key" {
  type        = string
  description = "SSH public key for the ec2 instance"
}

variable "instance_name" {
  type        = string
  description = "Name to be used for the EC2 instance"
}
