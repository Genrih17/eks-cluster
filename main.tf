provider "aws" {
  region = "eu-central-1" # Change to your region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "eks-cluster"
  cidr   = "10.0.0.0/16"
}

resource "aws_subnet" "private" {
  count                   = 2
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = element(module.vpc.private_subnets, count.index)
  availability_zone       = element(module.vpc.availability_zones, count.index)
  map_public_ip_on_launch = false
}

resource "aws_security_group" "eks_cluster_sg" {
  name_prefix = "eks-cluster-"
  vpc_id      = module.vpc.vpc_id

  # Ingress rules (inbound traffic)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["X.X.X.X/32"] # Example: Allow SSH from a specific IP
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Example: Allow HTTP from anywhere
  }

  # Egress rules (outbound traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

