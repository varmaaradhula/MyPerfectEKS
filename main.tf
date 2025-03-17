terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks-host.endpoint
    token                  = data.aws_eks_cluster_auth.eks-auth.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks-host.certificate_authority[0].data)
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks-host.endpoint
  token                  = data.aws_eks_cluster_auth.eks-auth.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks-host.certificate_authority[0].data)
}


locals {
  oidc_provider_id = regex("id/([A-Za-z0-9-]+)$", data.aws_eks_cluster.eks.identity[0].oidc[0].issuer)
}

# Convert list of subnets to a comma-separated string
locals {
  public_subnet_ids = join(",", module.vpc.public_subnets)  # ✅ Converts list to string
}


output "oidc_provider_id" {
  description = "OIDC Provider ID for the EKS Cluster"
  value       = local.oidc_provider_id
}