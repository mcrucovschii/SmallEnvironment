#-----------------------------------------------
# Example of a Small Environment
#
# 2 LBs (Custom Hardened Linux AMI)
# 2 Application-Server (default AWS AMI)
# 3 DB-Nodes (default AWS AMI)
# 3  VPCs/Networks & Sec-Groups to isolate DB from Applications from Public-Access (LB)
#
# output.tf
#----------------------------------------------
/*
output "webserver_instance_id" {
  value = aws_instance.WebServer.id
}
output "webserver_public_dns" {
  value = aws_instance.WebServer.public_dns
}
output "foo_ids" {
  value = data.aws_vpcs.foo.ids
}
output "aws_default_vpc_id" {
  value = aws_default_vpc.default.id

  output "latest_amazon_linux_id" {
    value = data.aws_ami.fresh_amazon_linux.id
  }
}
*/
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}
data "aws_availability_zones" "all" {}

data "aws_vpcs" "foo" {}
data "aws_vpc" "foo" {
  count = length(data.aws_vpcs.foo.ids)
  id    = tolist(data.aws_vpcs.foo.ids)[count.index]
}

data "aws_ami" "fresh_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }
}

output "data_aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}

output "data_aws_regions_name" {
  value = data.aws_region.current.name
}

output "aws_availability_zones" {
  value = data.aws_availability_zones.available.names
}

output "HAPEE_nodes_public_IPs" {
  value = aws_instance.hapee_node.*.public_ip
}
output "LB_HAPEE_DNS_address" {
  value = aws_lb.hapee_alb.dns_name
}

output "Web_node_public_IPs" {
  value = aws_instance.web_node.*.public_ip
}

output "Db_node_public_IPs" {
  value = aws_instance.db_node.*.public_ip
}
