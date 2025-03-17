

resource "kubernetes_ingress_v1" "alb_ingress" {
  metadata {
    name      = "my-ingress"
    namespace = "default"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"                               = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"                         = "ip"
      "alb.ingress.kubernetes.io/manage-backend-security-group-rules" = "true"
      "alb.ingress.kubernetes.io/subnets"                             = local.public_subnet_ids
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "my-app"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
  depends_on = [
   module.vpc,
   aws_eks_cluster.eks,
   helm_release.aws_load_balancer_controller
  ]
}