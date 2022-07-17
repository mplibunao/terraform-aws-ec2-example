locals {
  ec2_ami    = var.ami_type == "ec2" ? "amzn2-ami-kernel-5.10-hvm-2.0.202*-x86_64-gp2" : ""
  ecs_ami    = var.ami_type == "ecs" ? "amzn2-ami-ecs-hvm-2.0.202*-x86_64-ebs" : ""
  ubuntu_ami = var.ami_type == "ubuntu" ? "ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*" : ""
  ami_name   = coalesce(local.ec2_ami, local.ecs_ami, local.ubuntu_ami)
  owner      = var.ami_type == "ec2" || var.ami_type == "ecs" ? "amazon" : "099720109477"
}

data "aws_ami" "image" {
  most_recent = true

  filter {
    name   = "name"
    values = [local.ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [local.owner]
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.ssh_pub_key
}


resource "aws_instance" "my_server" {
  ami                    = data.aws_ami.image.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.my_server.id]
  subnet_id              = var.subnet_id

  tags = {
    Name = var.instance_name
  }
}

/**
resource "null_resource" "ec2-status" {
  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.my_server.id}"
  }

  depends_on = [
    aws_instance.my_server
  ]
}
**/
