# Example of a small environment

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

# Deploy
terraform apply --auto-approve

# Destroy
terraform destroy  --auto-approve

# Thank you!
