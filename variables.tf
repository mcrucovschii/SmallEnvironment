#-----------------------------------------------
# Example of a small environment
#
# 2 LBs (Custom Hardened Linux AMI)
# 2 Application-Server (default AWS AMI)
# 3 DB-Nodes (default AWS AMI)
# 3  VPCs/Networks & Sec-Groups to Isolate Application from DB from Public-Access to LB
#
# variables.tf
#----------------------------------------------

variable "region" {
  description = "Please, enter desired AWS region"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "MaxKeyPair"
}

variable "app_servers_count" {
  description = "Please, enter the number of app servers"
  default     = 2
}
variable "hapee_lb_count" {
  description = "Please, enter the number of LB servers"
  default     = 2
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
