# terraform init
# terraform plan
# terraform apply
# terraform destroy

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.41.0"
    }
  }
}

provider "aws" {
  # Configuration options
    region = "us-east-2"

}

# creative a vpc
resource "aws_vpc" "myvpc" {
  cidr_block = "172.20.0.0/16"
  tags={
    Name = "adeVPC"
  }
}

#create security group
resource "aws_security_group" "adevpc" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}






#provisioning EC2
resource "aws_instance" "ade" {
  ami           = "ami-0beaa649c482330f7" # us-east-2
  instance_type = "t2.micro"
  key_name = "adekey" 

  tags = {
    Name = "my_tag"
  }

}

