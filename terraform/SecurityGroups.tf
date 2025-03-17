resource "aws_security_group" "jump-server-sg" {
  name        = "jump-sg"
  description = "Security group for the application instances in private subnets"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["51.191.74.123/32"]  # Replace with your public IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jump Server Security Group"
  }
}

 # Security Group for Control Plane (API Server)
resource "aws_security_group" "eks_control_plane_sg" {
  vpc_id      = module.vpc.vpc_id
  description = "EKS Control Plane Security Group"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-control-plane-sg"
  }
}

resource "aws_security_group_rule" "worker_to_api" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_control_plane_sg.id
  source_security_group_id = data.aws_security_group.eks_default_node_sg.id
  description              = "Allow worker nodes to communicate with the EKS API server"
}

resource "aws_security_group_rule" "api_to_worker" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = data.aws_security_group.eks_default_node_sg.id
  source_security_group_id = aws_security_group.eks_control_plane_sg.id
  description              = "Allow API Server to communicate with worker nodes"
}

