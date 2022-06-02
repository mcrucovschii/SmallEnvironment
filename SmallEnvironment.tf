#-----------------------------------------------
# Example of a small environment
#
# 2 LBs (Custom Hardened Linux AMI)
# 2 Application-Server (default AWS AMI)
# 3 DB-Nodes (default AWS AMI)
# 3  VPCs/Networks & Sec-Groups to Isolate Application from DB from Public-Access to LB
#
# SmallEnvironment.tf
#----------------------------------------------

resource "aws_instance" "web_node" {
  count                  = var.app_servers_count
  instance_type          = var.instance_type
  ami                    = data.aws_ami.fresh_amazon_linux.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.lb_sg.id]
  subnet_id              = aws_subnet.PublicSubnetLB.id # aws_subnet.tf_test_subnet.id
  user_data              = file("tf-app-server-script.sh")
  tags = {
    Name = "web_node_${count.index}"
  }
}

data "template_file" "hapee-userdata" {
  template = file("hapee-userdata.sh.tpl")
  vars = {
    serverlist = join("\n", formatlist("    server app-%v %v:80 cookie app-%v check", aws_instance.web_node.*.id, aws_instance.web_node.*.private_ip, aws_instance.web_node.*.id))
  }
}
resource "aws_instance" "hapee_node" {
  count                  = var.hapee_lb_count
  instance_type          = var.instance_type
  ami                    = data.aws_ami.fresh_amazon_linux.id
  key_name               = var.key_name
  vpc_security_group_ids = ["${aws_security_group.instance_sg1.id}", "${aws_security_group.instance_sg2.id}"]
  subnet_id              = aws_subnet.PublicSubnetLB.id # aws_subnet.tf_test_subnet.id
  user_data              = data.template_file.hapee-userdata.rendered
  tags = {
    Name = "hapee_node_${count.index}"
  }
}

/*
resource "aws_instance" "WebServer" {
  ami                         = data.aws_ami.fresh_amazon_linux.id # Amazon Linux 2 Kernel 5.10 AMI 2.0.20220426.0 x86_64 HVM gp2
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.lb_sg.id]
  availability_zone           = data.aws_availability_zones.available.names[0]
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.PublicSubnetLB.id
  associate_public_ip_address = true
  user_data                   = file("tf-app-server-script.sh")
  tags = {
    Name = "Web Server Apache"
  }
}
*/
