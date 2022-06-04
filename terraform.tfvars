#-----------------------------------------------
# Example of a small environment
#
# 2 LBs (Custom Hardened Linux AMI)
# 2 Application-Server (default AWS AMI)
# 3 DB-Nodes (default AWS AMI)
# 3  VPCs/Networks & Sec-Groups to Isolate Application from DB from Public-Access to LB
#
# terraform.tfvars
#----------------------------------------------

region            = "us-west-2"
instance_type     = "t2.micro"
lb_allowed_ports  = ["22", "80"]
app_allowed_ports = ["22", "80", "8080", "443"]
key_name          = "MaxKeyPair"
app_servers_count = 2
hapee_lb_count    = 2
db_nodes_count    = 1
aws_az_count      = 2
