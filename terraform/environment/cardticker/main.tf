module "route_53" {
    source = "./../../modules/route53"
    zone_name   = var.zone_name
    create_zone = var.create_zone
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0" # pick a major you’re using

  name = "zerim-vpc"
  cidr = "172.20.0.0/16"

  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  # App/private subnets (one per AZ)
  private_subnets = [
    "172.20.10.0/24",
    "172.20.11.0/24",
    "172.20.12.0/24",
  ]

  # Public subnets (one per AZ)
  public_subnets = [
    "172.20.0.0/24",
    "172.20.1.0/24",
    "172.20.2.0/24",
  ]

  # Optional: data/db subnets (RDS, ElastiCache)
  # database_subnets = [
  #   "172.20.20.0/24",
  #   "172.20.21.0/24",
  #   "172.20.22.0/24",
  # ]

  enable_nat_gateway     = false
  single_nat_gateway     = false   # per-AZ NAT
  one_nat_gateway_per_az = true
  enable_dns_support = true
  enable_dns_hostnames = true
  enable_vpn_gateway = false
  map_public_ip_on_launch = true
  tags = {
    Terraform   = "true"
    Environment = "production"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"              = "1"
    "kubernetes.io/cluster/zerim-eks"     = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"     = "1"
    "kubernetes.io/cluster/zerim-eks"     = "shared"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"
  cluster_name    = "zerim-eks"
  cluster_version = "1.31"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  enable_irsa = true
  cluster_endpoint_public_access = true
  eks_managed_node_groups = {
    default = {
      name       = "ng-default"
      subnet_ids = module.vpc.public_subnets

      instance_types = ["t3.medium"]

      min_size     = 0
      max_size     = 2
      desired_size = 1
    }
  }
  access_entries = {
    ci_iac_admin = {
      principal_arn = "arn:aws:iam::542586609371:user/ci-iac"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
  tags = {
    Terraform   = "true"
    Environment = "production"
  }
}

module "alb_controller_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${module.eks.cluster_name}-alb-controller"

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }

  attach_load_balancer_controller_policy = true
}

output "alb_controller_role_arn" {
  value = module.alb_controller_irsa.iam_role_arn
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
