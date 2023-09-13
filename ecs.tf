module "ecs" {
  source                        = "terraform-aws-modules/ecs/aws"
  cluster_name                  = "eks-cluster"
  cluster_create_security_group = false
  cluster_security_group_ids    = [aws_security_group.eks_cluster_sg.id]
  tags = {
    Terraform   = "true"
    Environment = "eks-cluster"
  }
}

module "ecr" {
  source = "terraform-aws-modules/ecr/aws"
  name   = "eks-cluster"
}
