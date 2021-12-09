provider "aws" {
  region = var.region
}

provider "http" {

}

provider "tls" {
}

#############################################################
# Networking
#############################################################

data "aws_availability_zones" "available" {
  # exclude us-east-1e, not allowed
  # exclude_names = ["us-east-1e"]
}

data "aws_caller_identity" "current" {}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

output "vpc" {
  value = aws_default_vpc.default
}

resource "aws_default_subnet" "default_az" {
  count             = length(data.aws_availability_zones.available.names)
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

output "aws_default_subnet" {
  value = aws_default_subnet.default_az
}

locals {
  # create vpc and subnets
  vpc_id     = aws_default_vpc.default.id
  subnet_ids = aws_default_subnet.default_az[*].id
}

output "subnet_ids" {
  value = local.subnet_ids
}

#############################################################
# Admin EKS Cluster
#############################################################

# https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html
module "eks" {
  source  = "dabble-of-devops-bioanalyze/eks-autoscaling/aws"
  version = ">= 1.20.0"

  region                                        = var.region
  vpc_id                                        = local.vpc_id
  subnet_ids                                    = local.subnet_ids
  kubernetes_version                            = "1.19"
  oidc_provider_enabled                         = true
  cluster_encryption_config_enabled             = true
  eks_node_groups                               = var.eks_node_groups
  eks_node_group_autoscaling_enabled            = true
  eks_worker_group_autoscaling_policies_enabled = true
  install_ingress                               = true
  letsencrypt_email                             = "jillian@dabbleofdevops.com"

  context = module.this.context
}

data "null_data_source" "wait_for_cluster_and_kubernetes_configmap" {
  inputs = {
    cluster_name             = module.eks.eks_cluster_id
    kubernetes_config_map_id = module.eks.eks_cluster.kubernetes_config_map_id
  }
}

data "aws_eks_cluster" "cluster" {
  depends_on = [
    module.eks
  ]
  name = module.eks.eks_cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  depends_on = [
    module.eks
  ]
  name = module.eks.eks_cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# weird new bug in provider
# https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1234

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "null_resource" "kubectl_update" {
  depends_on = [
    module.eks,
    data.aws_eks_cluster_auth.cluster
  ]
  provisioner "local-exec" {
    command = "aws eks --region $AWS_REGION update-kubeconfig --name $NAME"
    environment = {
      AWS_REGION = var.region
      NAME       = module.eks.eks_cluster_id
    }
  }
}

output "eks" {
  value     = module.eks
  sensitive = true
}

module "nginx1" {
  depends_on = [
    module.eks,
    null_resource.kubectl_update,
  ]
  providers = {
    aws        = aws
    kubernetes = kubernetes
    helm       = helm
    http       = http
  }
  # source                     = "./../../"
  source  = "dabble-of-devops-bioanalyze/eks-helm/aws"
  version = ">= 0.0.2"
  # insert the 12 required variables here

  aws_route53_record_name    = "nginx1"
  aws_route53_zone_name      = var.aws_route53_zone_name
  helm_release_name          = "nginx1"
  helm_release_repository    = "https://charts.bitnami.com/bitnami"
  helm_release_chart         = "nginx"
  helm_release_version       = "9.5.16"
  helm_release_wait          = false
  helm_release_values_files  = [abspath("${path.module}/helm_charts/nginx1/values.yaml")]
  helm_release_values_dir    = abspath("${path.module}/helm_charts/nginx1")
  enable_ssl                 = true
  render_cluster_issuer      = true
  install_ingress            = false
  use_existing_ingress       = true
  existing_ingress_name      = "nginx-ingress-ingress-nginx-ingress-controller"
  existing_ingress_namespace = "default"
  letsencrypt_email          = "jillian@dabbleofdevops.com"
  context                    = module.this.context
}

output "nginx1" {
  value     = module.nginx1
  sensitive = true
}

module "nginx2" {
  depends_on = [
    module.eks,
    null_resource.kubectl_update,
  ]
  providers = {
    aws        = aws
    kubernetes = kubernetes
    helm       = helm
    http       = http
  }

  source                     = "../.."
  aws_route53_record_name    = "nginx2"
  aws_route53_zone_name      = var.aws_route53_zone_name
  helm_release_name          = "nginx2"
  helm_release_repository    = "https://charts.bitnami.com/bitnami"
  helm_release_chart         = "nginx"
  helm_release_version       = "9.5.16"
  helm_release_wait          = false
  helm_release_values_files  = [abspath("${path.module}/helm_charts/nginx2/values.yaml")]
  helm_release_values_dir    = abspath("${path.module}/helm_charts/nginx2")
  enable_ssl                 = true
  render_cluster_issuer      = true
  install_ingress            = false
  use_existing_ingress       = true
  existing_ingress_name      = "nginx-ingress-ingress-nginx-ingress-controller"
  existing_ingress_namespace = "default"
  letsencrypt_email          = "jillian@dabbleofdevops.com"
  context                    = module.this.context
}

output "nginx2" {
  value     = module.nginx2
  sensitive = true
}

resource "null_resource" "pytest" {
  count = var.run_tests ? 1 : 0
  depends_on = [
    module.nginx1,
    module.nginx2,
  ]
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "pip install -r tests/requirements.txt; python -m pytest -s --log-cli-level=INFO tests/test_helm_charts.py"
    environment = {
      AWS_REGION         = var.region
      AWS_DEFAULT_REGION = var.region
      LOG_LEVEL          = "INFO"
    }
  }
}
