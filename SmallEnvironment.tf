#-----------------------------------------------
# Example of a small environment
#
# 2 LBs (Custom Hardened Linux AMI)
# 2 Application-Server (default AWS AMI)
# 3 DB-Nodes (default AWS AMI)
# 3  VPCs/Networks & Sec-Groups to Isolate Application from DB from Public-Access to LB
#
# SmallEnvironment.tf
#----------------------------------------------


resource "aws_default_vpc" "default" {}
resource "aws_vpc" "VPC-LB" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "VPC-LB"
  }
}
resource "aws_vpc" "VPC-AppServers" {
  cidr_block           = "10.2.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "VPC-AppServers"
  }
}
resource "aws_vpc" "VPC-DBNodes" {
  cidr_block           = "10.3.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "VPC-DBNodes"
  }
}

resource "aws_subnet" "PublicSubnetLB" {
  vpc_id            = aws_vpc.VPC-LB.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = cidrsubnet(aws_vpc.VPC-LB.cidr_block, 4, 1)
  tags = {
    Name = "PublicSubnetLB"
  }
}
resource "aws_subnet" "PrivateSubnetAppServers" {
  vpc_id            = aws_vpc.VPC-AppServers.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = cidrsubnet(aws_vpc.VPC-AppServers.cidr_block, 4, 1)
  tags = {
    Name = "PrivateSubnetAppServers"
  }
}
resource "aws_subnet" "PrivateSubnetDBNodes" {
  vpc_id            = aws_vpc.VPC-DBNodes.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = cidrsubnet(aws_vpc.VPC-DBNodes.cidr_block, 4, 1)
  tags = {
    Name = "PrivateSubnetDBNodes"
  }
}


resource "aws_security_group" "LB_SG" {
  name   = "Load Balancer Security Group"
  vpc_id = aws_vpc.VPC-LB.id
  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "LB_SG"
  }
}

resource "aws_instance" "WebServer" {
  ami                         = data.aws_ami.fresh_amazon_linux.id # Amazon Linux 2 Kernel 5.10 AMI 2.0.20220426.0 x86_64 HVM gp2
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.LB_SG.id]
  availability_zone           = data.aws_availability_zones.available.names[0]
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.PublicSubnetLB.id
  associate_public_ip_address = true
  user_data                   = file("tf-app-server-script.sh")
  tags = {
    Name = "Web Server Apache"
  }
}
