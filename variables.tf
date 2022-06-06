#---------------------------------------------------------------------------------------
# Example of a small environment
#
# 2 LBs (Custom Hardened Linux AMI)
# 2 Application-Server (default AWS AMI)
# 3 DB-Nodes (default AWS AMI)
# 3  VPCs/Networks & Sec-Groups to Isolate Application from DB from Public-Access to LB
#
# variables.tf
# region - region where infrastructure will be deployed
# instance_type - instance_type that will be used for hapee, web nodes and db nodes
# hapee_lb_count - a number of hapee balancers to be launched
# key_name - please, check if you have a key pair with this name in the region you are going to deploym
# app_servers_count - a number of app servers (web nodes) to be launched
# db_nodes_count - a number of db nodes to be launched
# aws_az_count - a number of availability zones  where infrastructure will be deployed
# lb_allowed_ports - ports allowed at load balancers (hapee nodes)
# app_allowed_ports - ports allowed at app servers (web nodes)
# db_allowed_ports - ports allowed at db servers (db nodes)
#----------------------------------------------------------------------------------------
#
variable "region" {
  description = "Please, enter desired AWS region"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "key_name" {
  default = "MaxKeyPair"
}
variable "hapee_lb_count" {
  description = "Please, enter the number of LB servers"
  default     = 2
}
variable "app_servers_count" {
  description = "Please, enter the number of app servers"
  default     = 2
}
variable "db_nodes_count" {
  description = "Please, enter the number of db nodes"
  default     = 1
}
variable "aws_az_count" {
  description = "Please, enter the number of AZ for deployment"
  default     = 1
}
variable "lb_allowed_ports" {
  type    = list(any)
  default = ["22", "80"]
}
variable "app_allowed_ports" {
  type    = list(any)
  default = ["22", "80", "8080", "443"]
}
variable "db_allowed_ports" {
  type    = list(any)
  default = ["22", "3306"]
}
