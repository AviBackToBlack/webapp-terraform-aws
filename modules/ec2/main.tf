data "aws_ami" "amazon_linux_2" {
 most_recent = true
 owners = [ "amazon" ]
 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
 filter {
    name   = "virtualization-type"
    values = ["hvm"]
 }
}

data "template_file" "script_bastion" {
  template = "${file("${path.module}/templates/bastion-init.tpl")}"
  vars = {
    hostname   = "bastion"
    aws_region = var.aws_region
    user_role  = var.user_role
  }
}

data "template_file" "script_webserver" {
  template = "${file("${path.module}/templates/webserver-init.tpl")}"
  vars = {
    hostname   = "webserver"
    aws_region = var.aws_region
    user_role  = var.user_role
  }
}

data "template_cloudinit_config" "cloudinit_config_bastion" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.script_bastion.rendered}"
  }
}

data "template_cloudinit_config" "cloudinit_config_webserver" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.script_webserver.rendered}"
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.ec2_instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [ var.public_security_group_id ]
  iam_instance_profile        = var.bastion_profile_id
  user_data                   = data.template_cloudinit_config.cloudinit_config_bastion.rendered
  key_name                    = var.key_pair
  associate_public_ip_address = true
  root_block_device  {
    volume_size           = var.ec2_volume_size
    volume_type           = "gp2"
    delete_on_termination = true
  }
  tags = {
    Name = "${var.project_name} bastion"
  }
}

resource "aws_instance" "webserver" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.ec2_instance_type
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [ var.private_security_group_id ]
  iam_instance_profile        = var.webserver_profile_id
  user_data                   = data.template_cloudinit_config.cloudinit_config_webserver.rendered
  key_name                    = var.key_pair
  associate_public_ip_address = true
  root_block_device  {
    volume_size           = var.ec2_volume_size
    volume_type           = "gp2"
    delete_on_termination = true
  }
  tags = {
    Name = "${var.project_name} webserver"
  }
}
