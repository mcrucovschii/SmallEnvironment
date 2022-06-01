#-----------------------------------------------
# Apache Web Server
#
# Build by Terraform
# Main deployment module 
#----------------------------------------------

variable "region" {
  description = "Please, enter AWS region"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_max_name" {
  default = "MaxKeyPair"
}

variable "allowed_ports" {
  type    = list(any)
  default = ["22", "80"]
}
