# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = "AKIAUIBWTBRNPRV5MR6K"
  secret_key = "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"
}

# resource "<provider>_<resource_type>" "name" {
#     config options....connection {
#     key = "value"
#     key2 = "another value"
#     }
# }

# resource "aws_instance" "terraform_demo" {
#   ami           = "ami-09d56f8956ab235b3"
#   instance_type = "t2.micro"
#   tags = {
#       Name = "terrform-ec2-1-ubuntu"
#   }

## AWS Project

# # 1. Create VPC
# resource "aws_vpc" "terraform_vpc" {
#   cidr_block = "10.0.0.0/16"
#   tags = {
#       Name = "prod"
#         }
# }

# # Showing output
# output "vpc_id" {
#     value = aws_vpc.terraform_vpc.cidr_block
# }
# # 2. Create internet gateway
# resource "aws_internet_gateway" "terraform_igw" {
#   vpc_id = aws_vpc.terraform_vpc.id
#   tags = {
#     Name = "terraform_igw_prod"
#   }
# }

# # 3. Create custom route table for ipv4 and ipv6
# resource "aws_route_table" "terraform_route" {
#   vpc_id = aws_vpc.terraform_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.terraform_igw.id
#   }
# #   route {
# #     cidr_block = "::/0"
# #     egress_only_gateway_id = aws_internet_gateway.terraform_igw.id
# #   }
#   tags = {
#       Name = "Prod"
#   }
# }

# # 4. Create a subnet for webserver
# resource "aws_subnet" "terraform_subnet-1" {
#   vpc_id            = aws_vpc.terraform_vpc.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = "terraform-prod-sub"
#   }
# }

# # 5. Associate subnet with route table 
# resource "aws_route_table_association" "a" {
#   subnet_id      = aws_subnet.terraform_subnet-1.id
#   route_table_id = aws_route_table.terraform_route.id
# }

# # 6. Create a security group for webserver
# resource "aws_security_group" "allow_web" {
#   description = "Allow web"
#   vpc_id      = aws_vpc.terraform_vpc.id

#   ingress {
#     description      = "https from VPC"
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     #ipv6_cidr_blocks = [aws_vpc.terraform_vpc.ipv6_cidr_block]
#   }
#   ingress {
#     description      = "http from VPC"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     #ipv6_cidr_blocks = [aws_vpc.terraform_vpc.ipv6_cidr_block]
#   }
#   ingress {
#     description      = "ssh from VPC"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     #ipv6_cidr_blocks = [aws_vpc.terraform_vpc.ipv6_cidr_block]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     #ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "allow_web"
#   }
# }

# # 7.Allow network interface (Private iP)
# resource "aws_network_interface" "web_server_nic" {
#   subnet_id       = aws_subnet.terraform_subnet-1.id
#   private_ips     = ["10.0.1.50"]
#   security_groups = [aws_security_group.allow_web.id]
# }

# # 8.Create elastic ip for public access
# resource "aws_eip" "terraform_eip" {
#   vpc      = true
#   network_interface = aws_network_interface.web_server_nic.id
#   associate_with_private_ip = "10.0.1.50"
#   depends_on = [aws_internet_gateway.terraform_igw]
# }

# # 9. Create ubuntu instance
# resource "aws_instance" "terraform_demo" {
#     ami           = "ami-09d56f8956ab235b3"
#     instance_type = "t2.micro"
#     availability_zone = "us-east-1a"
#     key_name = "terraform-key"
#     network_interface {
#         device_index = 0
#         network_interface_id = aws_network_interface.web_server_nic.id
#     }
#     user_data = <<-EOF
#         #!/bin/bash
#         sudo apt update -y
#         sudo apt install apache2 -y
#         sudo systemctl start apache2
#         sudo bash -c 'echo your very first web server using terraform > /var/www/html/index.html'
#         EOF
#     tags = {
#         Name = "web-server"
#     }
# }




# terraform variables

variable "subnet_prefix" {
  description = "cidr block"
  type = string
  default = "10.0.66.0/24"
}

# 1. Create VPC
resource "aws_vpc" "terraform_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
      Name = "prod"
  }
}
resource "aws_subnet" "terraform_subnet-1" {
    vpc_id            = aws_vpc.terraform_vpc.id
    cidr_block        = var.subnet_prefix
    availability_zone = "us-east-1a"

   tags = {
     Name = "terraform-prod-sub"
   }
}