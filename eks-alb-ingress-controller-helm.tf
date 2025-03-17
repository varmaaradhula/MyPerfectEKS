# Install AWS Load Balancer Controller using Helm
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"  # Directly specify the repo
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = "barista-eks-cluster"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "region"
    value = "eu-west-2"
  }

  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }

  depends_on = [
    kubernetes_service_account.alb_ingress_controller
  ]
}