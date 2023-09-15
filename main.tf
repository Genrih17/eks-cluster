provider "aws" {
  region = var.aws-region
}

data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = var.vpc_name
  cidr   = var.vpc_cidr
  azs    = slice(data.aws_availability_zones.available.names, 0, 2)

  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}



module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster-name
  cluster_version = "1.27"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true


  eks_managed_node_groups = {
    first = {
      name             = "node-group-1"
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1
      instance_type    = "t3.small"
    }
  }
}


#resource "terraform_data" "config" {
#  depends_on = [module.eks]
#  provisioner "local-exec" {
#    command = "aws eks --region eu-central-1  update-kubeconfig --name eks-cluster"
#    #environment = {
#    #AWS_CLUSTER_NAME = var.cluster-name
#    #REGION           = var.aws-region
#    #}
#  }
#}

