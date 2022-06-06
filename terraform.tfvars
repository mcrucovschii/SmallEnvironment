#-----------------------------------------------
# Example of a small environment
#
# 2 LBs (Custom Hardened Linux AMI)
# 2 Application-Server (default AWS AMI)
# 3 DB-Nodes (default AWS AMI)
# 3  VPCs/Networks & Sec-Groups to Isolate Application from DB from Public-Access to LB
#
#  Please, adjust your setup here
#
# region - region where infrastructure will be deployed
# instance_type - instance_type that will be used for hapee, web nodes and db nodes
# hapee_lb_count - a number of hapee balancers to be launched
# key_name - please, check if you have a key pair with this name in the region you are going to deploy
# app_servers_count - a number of app servers (web nodes) to be launched
# db_nodes_count - a number of db nodes to be launched
# aws_az_count - a number of availability zones  where infrastructure will be deployed
# lb_allowed_ports - ports allowed at load balancers (hapee nodes)
# app_allowed_ports - ports allowed at app servers (web nodes)
# db_allowed_ports - ports allowed at db servers (db nodes)
#
# terraform.tfvars
#----------------------------------------------

#region            = "us-west-2"     # dev zone
region            = "eu-central-1" # prod zone
instance_type     = "t2.micro"
key_name          = "MaxKeyPair"
app_servers_count = 2
hapee_lb_count    = 2
db_nodes_count    = 3
aws_az_count      = 2
lb_allowed_ports  = ["22", "80"]
app_allowed_ports = ["22", "80", "8080", "443"]
db_allowed_ports  = ["22", "3306"]
