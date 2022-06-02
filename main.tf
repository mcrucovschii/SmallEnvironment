#-----------------------------------------------
# Example of a small environment
#
# 2 LBs (Custom Hardened Linux AMI)
# 2 Application-Server (default AWS AMI)
# 3 DB-Nodes (default AWS AMI)
# 3  VPCs/Networks & Sec-Groups to Isolate Application from DB from Public-Access to LB
#
# Enter your AWS credentials
# export AWS_ACCESS_KEY_ID=""\
# export AWS_SECRET_ACCESS_KEY=""
# main.tf
#----------------------------------------------

provider "aws" {
  region = var.region
}
