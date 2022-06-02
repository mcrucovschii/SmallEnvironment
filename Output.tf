#-----------------------------------------------
# Example of a small environment
#
# 2 LBs (Custom Hardened Linux AMI)
# 2 Application-Server (default AWS AMI)
# 3 DB-Nodes (default AWS AMI)
# 3  VPCs/Networks & Sec-Groups to Isolate Application from DB from Public-Access to LB
#
# output.tf
#----------------------------------------------

output "webserver_instance_id" {
  value = aws_instance.WebServer.id
}
output "webserver_public_dns" {
  value = aws_instance.WebServer.public_dns
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

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
  value = data.aws_availability_zones.available.names[0]
}

output "latest_amazon_linux_id" {
  value = data.aws_ami.fresh_amazon_linux.id
}

output "foo_ids" {
  value = data.aws_vpcs.foo.ids
}

output "aws_default_vpc_id" {
  value = aws_default_vpc.default.id
}

/*
output "vpc_selected" {
  value = data.aws_vpc.selected.id
}*/
