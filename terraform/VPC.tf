module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-barista-vpc"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = true
  enable_dns_hostnames = true
  enable_dns_support  = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }

public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"  # Enables ELB in public subnets
    "kubernetes.io/cluster/barista-eks-cluster" = "owned"
  }

}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}