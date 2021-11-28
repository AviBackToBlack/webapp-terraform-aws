data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "bastion" {
  name               = "bastion-role"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
  tags = {
    Name = "${var.project_name} bastion role"
  }
}

resource "aws_iam_role" "webserver" {
  name               = "webserver-role"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
  tags = {
    Name = "${var.project_name} webserver role"
  }
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "bastion-profile"
  role = aws_iam_role.bastion.name
  tags = {
    Name = "${var.project_name} bastion instance profile"
  }
}

resource "aws_iam_instance_profile" "webserver_profile" {
  name = "webserver-profile"
  role = aws_iam_role.webserver.name
  tags = {
    Name = "${var.project_name} webserver profile"
  }
}

data "template_file" "template_file_role_policy_bastion" {
  template = file("${path.module}/templates/role_policy_bastion_${var.user_role}.json.tpl")
  vars = {
    s3_bucket_name = var.s3_bucket_name
  }
}

data "template_file" "template_file_role_policy_webserver" {
  template = file("${path.module}/templates/role_policy_webserver_${var.user_role}.json.tpl")
  vars = {
    s3_bucket_name = var.s3_bucket_name
  }
}

resource "aws_iam_role_policy" "role_policy_bastion" {
  name   = "role-policy-bastion"
  role   = aws_iam_role.bastion.id
  policy = data.template_file.template_file_role_policy_bastion.rendered
}

resource "aws_iam_role_policy" "role_policy_webserver" {
  name   = "role-policy-webserver"
  role   = aws_iam_role.webserver.id
  policy = data.template_file.template_file_role_policy_webserver.rendered
}
