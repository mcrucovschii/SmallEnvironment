#-----------------------------------------------
# Example of a small environment
#
# 2 LBs (Custom Hardened Linux AMI)
# 2 Application-Server (default AWS AMI)
# 3 DB-Nodes (default AWS AMI)
# 3  VPCs/Networks & Sec-Groups to Isolate Application from DB from Public-Access to LB
#
# 1) How can this be put into a GitHub Action Pipeline to get applied when merged?
# 2) Is there any other way to maybe integrate it into our AWX(Ansible Tower) infrastructure to Reflect a IaaC Approach?
# What could be the best way to distribute Traffic over 2 LBs or would you prefer Active/Passive?
# 3) How can this be done without any interaction?
# 4) present the examples and you thoughts about the Challanges and mind-gaps in this Request?
#
# SmallEnvironment.tf
#----------------------------------------------
#########   instances  - db, app, hapee #######
#
########### declaration of db node instance
resource "aws_instance" "db_node" {
  count                  = var.db_nodes_count
  instance_type          = var.instance_type
  ami                    = data.aws_ami.fresh_amazon_linux.id
  key_name               = var.key_name
  vpc_security_group_ids = ["${aws_security_group.dbnode_sg.id}"]
  subnet_id              = element(aws_subnet.PrivateSubnetDBNodes.*.id, count.index)
  user_data              = file("tf-db-node-script.sh")
  tags = {
    Name = "db_node_${count.index}"
  }
}

########### declaration of app server (web node) instance
data "template_file" "db-userdata" {
  template = file("tf-app-server-script.sh")
  vars = {
    dbhost = aws_instance.db_node[0].private_ip
    # uses private ip to connect to DB
  }
}
resource "aws_instance" "web_node" {
  count                       = var.app_servers_count
  instance_type               = var.instance_type
  ami                         = data.aws_ami.fresh_amazon_linux.id
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = ["${aws_security_group.app_sg.id}"]
  subnet_id                   = element(aws_subnet.PrivateSubnetAppServers.*.id, count.index)
  user_data                   = data.template_file.db-userdata.rendered
  tags = {
    Name = "web_node_${count.index}"
  }
}

########### declaration of load balancer (hapee node) instance
data "template_file" "hapee-userdata" {
  template = file("hapee-userdata.sh.tpl")
  vars = {
    serverlist = join("\n", formatlist("    server app-%v %v:80 cookie app-%v check", aws_instance.web_node.*.id, aws_instance.web_node.*.private_ip, aws_instance.web_node.*.id))
    # uses private ip to connect to App servers (web nodes)
  }
}
resource "aws_instance" "hapee_node" {
  count                       = var.hapee_lb_count
  instance_type               = var.instance_type
  ami                         = data.aws_ami.fresh_amazon_linux.id
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = ["${aws_security_group.lb_sg.id}"]
  subnet_id                   = element(aws_subnet.PublicSubnetLB.*.id, count.index)
  user_data                   = data.template_file.hapee-userdata.rendered
  tags = {
    Name = "hapee_node_${count.index}"
  }
}
