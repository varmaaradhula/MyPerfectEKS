data "aws_availability_zones" "available" {

}

data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.eks.name
}

data "aws_security_group" "eks_default_node_sg" {
  id = data.aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}

data "aws_eks_cluster" "eks-host" {
  name = aws_eks_cluster.eks.name
}

data "aws_eks_cluster_auth" "eks-auth" {
  name = aws_eks_cluster.eks.name
}

data "tls_certificate" "eks_oidc" {
  url = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

