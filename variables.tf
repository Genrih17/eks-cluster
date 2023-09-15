variable "aws-region" {
  default     = "eu-central-1" #change to your region
  type        = string
  description = "The AWS Region to deploy resources"
}

# Variables for VPC resource

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "cluster-vpc"
}


variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_private_subnets" {
  description = "Private subnets for VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}


# Cluster variables

variable "cluster-name" {
  default     = "eks-cluster"
  type        = string
  description = "The name of EKS Cluster"
}
