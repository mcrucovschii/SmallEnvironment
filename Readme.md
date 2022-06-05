#--------------------------------------------------------------------------------------
# Example of a small environment
#
# 2 LBs (Custom Hardened Linux AMI)
# 2 Application-Server (default AWS AMI)
# 3 DB-Nodes (default AWS AMI)
# 3  VPCs/Networks & Sec-Groups to Isolate Application from DB from Public-Access to LB
#
# SmallEnvironment.tf
#--------------------------------------------------------------------------------------

# Enter your AWS credentials
export AWS_ACCESS_KEY_ID=""\
export AWS_SECRET_ACCESS_KEY=""

# Init
terraform init

#Configure terraform.tfvars
#region            = "us-west-2"
#instance_type     = "t2.micro"
#key_name          = "YourKeyPair"
#app_servers_count = 2
#hapee_lb_count    = 2
#db_nodes_count    = 3
#aws_az_count      = 2

# Deploy!
terraform apply --auto-approve

# Destroy
terraform destroy  --auto-approve

# Thank you!
