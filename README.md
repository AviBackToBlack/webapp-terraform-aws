# Webapp Terraform AWS

## About The Project

This project contains Terraform code for creating an instance running Apache
HTTP server in a private subnet on AWS and a bastion server in a public
subnet which can be used for SSH and HTTP access to the webserver.

## Prerequisites

* [Terraform](https://www.terraform.io/) version `1.0.11`. You may install required version with [tfenv](https://github.com/tfutils/tfenv) (see below)
* [AWS Command Line Interface](https://aws.amazon.com/cli/)
* [Git](https://git-scm.com/)
* [AWS](https://aws.amazon.com/) IAM or root (not recommended) user having access key configured and permissions to manage VPC, S3, IAM, Secrets Manager and EC2 resources

## Installation

* Clone the repo

   ```sh
   git clone https://github.com/AviBackToBlack/webapp-terraform-aws.git
   (Optional) cd webapp-terraform-aws && tfenv install
   ```

## Credentials and Variables

* Set the `AWS_DEFAULT_REGION`, `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables:

   ```sh
   read -p "Enter AWS Default Region: " AWS_DEFAULT_REGION && export AWS_DEFAULT_REGION && echo
   read -s -p "Enter AWS Access Key ID: " AWS_ACCESS_KEY_ID && export AWS_ACCESS_KEY_ID && echo
   read -s -p "Enter AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY && export AWS_SECRET_ACCESS_KEY && echo
   ```

* Check that you already have a key pair created in the target AWS account and retreive its name. If you do not have any key pairs you may create a new key pair using the following command:

  ```sh
  aws ec2 create-key-pair --key-name [projectname]-key-pair --query "KeyMaterial" --output text >[projectname]-key-pair.pem
  ```

* Create two files `testusersecrets.json` and `devusersecrets.json` containing user names and their public keys that will be created on the servers using the following format:

  ```json
  {
    "john":"ssh-rsa AAA... john-rsa-key-XXXXXXXX",
    "james":"ssh-rsa AAA... james-rsa-key-XXXXXXXX"
  }
  ```

* Create secrets containing user public keys in the AWS Secrets Manager:

  ```sh
  aws secretsmanager create-secret --name test/publickeys --description "Test Public Keys" --secret-string file://testusersecrets.json
  aws secretsmanager create-secret --name dev/publickeys --description "Dev Public Keys" --secret-string file://devusersecrets.json
  ```

* Check that you have S3 backend bucket in place and retreive its name. If you do not have any S3 buckets that you want to use as S3 backend bucket you may create new using the following commands:

  ```sh
  aws s3api create-bucket --acl private --bucket [projectname]-terraform-state --region us-east-1
  aws s3api put-bucket-encryption --bucket [projectname]-terraform-state --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'
  ```

* Populate the following variables:
  | Variable Name | Location         | Description                              | Example                  |
  |---------------|------------------|------------------------------------------|--------------------------|
  | aws_region    | terraform.tfvars | AWS Region                               | "us-east-1"              |
  | project_name  | terraform.tfvars | Project mame                             | "webapp"                 |
  | user_role     | terraform.tfvars | User role. Can be either "dev" or "test" | "test"                   |
  | key_pair      | terraform.tfvars | Existing AWS key pair name               | "webapp-key-pair"        |
  | owner_email   | terraform.tfvars | Owner email address                      | "someone@example.com"    |
  | bucket        | main.tf          | S3 backend bucket name                   | "webapp-terraform-state" |
  | region        | main.tf          | S3 backend bucket region                 | "us-east-1"              |

## Usage

* Run the following commands:

  ```sh
  terraform init
  terraform apply
  ```

* Check the output to find the Bastion server public hostname, the Webserver private ip address and S3 bucket name:

  ```text
  bastion_public_hostname = "ec2-XXX-XXX-XXX-XXX.compute-1.amazonaws.com"
  s3_bucket_name = "projectname-role-XXXXXXXXXXXXXXXXXXXXXXXXXX"
  webserver_private_ip = "192.168.1.XXX"
  ```

## Destroy

* Run the following command to destroy all resources:

  ```sh
  terraform destroy
  ```

* Unset variables:

  ```sh
  unset AWS_DEFAULT_REGION
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  ```
