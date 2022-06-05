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

########### VPCs declaration ###################
resource "aws_default_vpc" "default" {}

resource "aws_vpc" "VPC-LB" {
  cidr_block           = "10.101.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "VPC-LB"
  }
}
resource "aws_vpc" "VPC-AppServers" {
  cidr_block           = "10.102.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "VPC-AppServers"
  }
}
resource "aws_vpc" "VPC-DBNodes" {
  cidr_block           = "10.103.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "VPC-DBNodes"
  }
}
################# VPC Peering #########################
resource "aws_vpc_peering_connection" "VPC1-2" {
  peer_vpc_id = aws_vpc.VPC-AppServers.id
  vpc_id      = aws_vpc.VPC-LB.id
  auto_accept = true
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  requester {
    allow_remote_vpc_dns_resolution = true
  }
  tags = {
    Name = "VPC Peering between Load Balancers and Web nodes"
  }
}
resource "aws_vpc_peering_connection" "VPC2-3" {
  peer_vpc_id = aws_vpc.VPC-AppServers.id
  vpc_id      = aws_vpc.VPC-DBNodes.id
  auto_accept = true
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  requester {
    allow_remote_vpc_dns_resolution = true
  }
  tags = {
    Name = "VPC Peering between Web nodes and DB nodes"
  }
}
################## subnet declaration #################
resource "aws_subnet" "PublicSubnetLB" {
  #count             = var.aws_az_count
  vpc_id            = aws_vpc.VPC-LB.id
  cidr_block        = cidrsubnet(aws_vpc.VPC-LB.cidr_block, 4, 1)
  availability_zone = data.aws_availability_zones.available.names[0]
  #availability_zone       = data.aws_availability_zones.available.names[count.index]
  #map_public_ip_on_launch = true
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
resource "aws_subnet" "tf_test_subnet" {
  count                   = var.aws_az_count
  vpc_id                  = aws_vpc.VPC-LB.id
  cidr_block              = cidrsubnet(aws_vpc.VPC-LB.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.all.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "hapee_test_subnet"
  }
}

############# Security groups #############################
# aws_security_group.lb_sg  Load balancers (hapee and ALB)
#
resource "aws_security_group" "lb_sg" {
  name   = "Load Balancer Security Group"
  vpc_id = aws_vpc.VPC-LB.id
  dynamic "ingress" {
    for_each = var.lb_allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "LB_SG"
  }
}

resource "aws_security_group" "instance_sg1" {
  name        = "instance_sg1"
  description = "Instance (HAProxy/App node) SG to pass tcp/22 by default"
  vpc_id      = aws_vpc.VPC-LB.id # aws_vpc.VPC-AppServers.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
  ingress {
    from_port   = 0
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
}
resource "aws_security_group" "instance_sg2" {
  name        = "instance_sg2"
  description = "Instance (HAProxy/App node) SG to pass LB traffic  by default"
  vpc_id      = aws_vpc.VPC-LB.id # aws_vpc.VPC-AppServers.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "elb" {
  name   = "elb_sg"
  vpc_id = aws_vpc.VPC-LB.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
##################### gateway declaration ###############
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.VPC-LB.id
}

##################### route table declaration ############
resource "aws_route_table" "r" {
  vpc_id = aws_vpc.VPC-LB.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "VPC-LB-GW"
  }
}
resource "aws_route_table_association" "a" {
  count          = var.aws_az_count
  subnet_id      = element(aws_subnet.tf_test_subnet.*.id, count.index)
  route_table_id = aws_route_table.r.id
}
/*
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.PublicSubnetLB.id
  route_table_id = aws_route_table.r.id
}*/

############## ALB ##############################
resource "aws_lb" "hapee_alb" {
  name            = "hapee-test-alb"
  internal        = false
  subnets         = toset(aws_subnet.tf_test_subnet[*].id)
  security_groups = ["${aws_security_group.elb.id}"]
  tags = {
    Name = "hapee_alb"
  }
}
resource "aws_lb_target_group" "hapee_alb_target" {
  name     = "hapee-test-alb-tg"
  vpc_id   = aws_vpc.VPC-LB.id
  port     = 80
  protocol = "HTTP"
  health_check {
    interval            = 30
    path                = "/haproxy_status"
    port                = 8080
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200,202"
  }
  tags = {
    Name = "hapee_alb_tg"
  }
}
resource "aws_lb_listener" "hapee_alb_listener" {
  load_balancer_arn = aws_lb.hapee_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.hapee_alb_target.arn
    type             = "forward"
  }
}
resource "aws_lb_target_group_attachment" "hapee_alb_target_att" {
  count            = var.hapee_lb_count * var.aws_az_count
  target_group_arn = aws_lb_target_group.hapee_alb_target.arn
  target_id        = element(aws_instance.hapee_node.*.id, count.index)
  port             = 80
}
############## ALB RDS ##############################
resource "aws_lb" "db_alb" {
  name            = "db-test-alb"
  internal        = false
  subnets         = toset(aws_subnet.tf_test_subnet[*].id)
  security_groups = ["${aws_security_group.elb.id}"]
  tags = {
    Name = "db_alb"
  }
}
resource "aws_lb_target_group" "db_alb_target" {
  name     = "db-test-alb-tg"
  vpc_id   = aws_vpc.VPC-LB.id
  port     = 3306
  protocol = "TCP"
  health_check {
    interval = 30
    #path                = "/haproxy_status"
    port     = 3306
    protocol = "TCP"
    #timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    #matcher             = "200,202"
  }
  tags = {
    Name = "hapee_alb_tg"
  }
}
/*
resource "aws_lb_listener" "db_alb_listener" {
  load_balancer_arn = aws_lb.db_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.db_alb_target.arn
    type             = "forward"
  }
}*/
resource "aws_lb_target_group_attachment" "db_alb_target_att" {
  count            = var.db_nodes_count
  target_group_arn = aws_lb_target_group.db_alb_target.arn
  target_id        = element(aws_instance.db_node.*.id, count.index)
  port             = 3306
}
######################### DNS ###############################
/*
resource "aws_elb" "main" {
  name               = "foobar-terraform-elb"
  availability_zones = ["us-east-1c"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "example.com"
  type    = "A"

  alias {
    name                   = aws_elb.main.dns_name
    zone_id                = aws_elb.main.zone_id
    evaluate_target_health = true
  }
}
*/
