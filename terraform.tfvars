# Common
aws_region   = "" # AWS Region Name (https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html#Concepts.RegionsAndAvailabilityZones.Regions)
project_name = "" # Project Name
user_role    = "" # User Role. Can be either dev or test
key_pair     = "" # The name of the existing AWS Key Pair that will be used for creating EC2 instances
owner_email  = "" # Owner email address

# VPC
vpc_cidr_block                = "192.168.0.0/23"
vpc_public_subnet_cidr_block  = "192.168.0.0/24"
vpc_private_subnet_cidr_block = "192.168.1.0/24"

# EC2
ec2_instance_type = "t2.micro"
ec2_volume_size   = "10"
