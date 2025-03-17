resource "aws_iam_openid_connect_provider" "eks_oidc" {
  url             = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint]
}

# Create IAM Role for ALB Ingress Controller
resource "aws_iam_role" "alb_ingress_role" {
  name = "AmazonEKS_ALB_Ingress_Controller"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.eks_oidc.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })
}

# Attach AWS Load Balancer Controller IAM Policy
resource "aws_iam_role_policy_attachment" "alb_ingress_policy_attachment" {
  policy_arn = "arn:aws:iam::400675223919:policy/AWSLoadBalancerControllerIAMPolicy"
  role       = aws_iam_role.alb_ingress_role.name
}

# Kubernetes Service Account with IAM Role Binding
resource "kubernetes_service_account" "alb_ingress_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_ingress_role.arn
    }
  }
  depends_on = [
    aws_iam_openid_connect_provider.eks_oidc,
    aws_iam_role.alb_ingress_role,
    aws_iam_role_policy_attachment.alb_ingress_policy_attachment
  ]
}
