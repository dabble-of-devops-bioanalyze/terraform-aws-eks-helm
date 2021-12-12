#######################################################
# terraform-aws-eks-helm
#######################################################

locals {
  ingress_template        = length(var.ingress_template) > 0 ? var.ingress_template : "${path.module}/helm_charts/bitnami/ingress.yaml.tpl"
  cluster_issuer_template = length(var.cluster_issuer_template) > 0 ? var.cluster_issuer_template : "${path.module}/helm_charts/cluster-issuer.yaml.tpl"
}

resource "null_resource" "helm_dirs" {
  provisioner "local-exec" {
    command = "mkdir -p ${var.helm_release_values_dir}"
  }
}

# # merged values files
# # if one is not supplied supply it here
resource "random_string" "computed_values" {
  count            = length(var.helm_release_merged_values_file) == 0 ? 1 : 0
  length           = 10
  special          = false
  lower            = true
  upper            = false
  override_special = ""
}

locals {
  helm_release_merged_values_file = length(var.helm_release_merged_values_file) == 0 ? abspath("${var.helm_release_values_dir}/computed-${random_string.computed_values[0].result}-values.yaml") : var.helm_release_merged_values_file
}

# # If the computed-values file does not exist we must create it first
resource "null_resource" "create_merged_file" {
  depends_on = [
    local.helm_release_merged_values_file,
    random_string.computed_values
  ]
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = <<EOT
    mkdir -p ${var.helm_release_values_dir}
    touch ${local.helm_release_merged_values_file}
    touch ${var.helm_release_values_dir}/cluster-issuer.yaml
    touch ${var.helm_release_values_dir}/ingress.yaml
    EOT
  }
}

# module "helm_ingress" {
#   count                   = var.enable_ssl == true && var.install_ingress == true ? 1 : 0
#   # source                  = "dabble-of-devops-bioanalyze/eks-bitnami-nginx-ingress/aws"
#   # version                 = ">= 0.2.0"
#   source                  = "/root/terraform-recipes/terraform-aws-eks-bitnami-nginx-ingress"
#   letsencrypt_email       = trimspace(var.letsencrypt_email)
#   helm_release_values_dir = trimspace(var.helm_release_values_dir)
#   helm_release_name       = trimspace(var.helm_release_name)
#   helm_release_namespace  = trimspace(var.helm_release_namespace)
#   install_ingress =  var.install_ingress
#   use_existing_ingress = var.use_existing_ingress
#   existing_ingress_name = var.existing_ingress_name
#   existing_ingress_namespace = var.existing_ingress_namespace
#   # we'll do this in the main module
#   render_cluster_issuer = false
# }

# #################################################################
# # Case: Install new ingress
# #################################################################

data "kubernetes_service" "helm_ingress" {
  count = var.enable_ssl == true && var.install_ingress == true ? 1 : 0
  depends_on = [
    module.helm_ingress
  ]
  metadata {
    name      = "${var.helm_release_name}-ingress-nginx-ingress-controller"
    namespace = var.helm_release_namespace
  }
}

data "aws_elb" "helm_ingress" {
  count = var.enable_ssl == true && var.install_ingress == true ? 1 : 0
  depends_on = [
    data.kubernetes_service.helm_ingress[0]
  ]
  name = split("-", data.kubernetes_service.helm_ingress[0].status.0.load_balancer.0.ingress.0.hostname)[0]
}

# #################################################################
# # Case: Use Existing Ingress
# #################################################################

data "kubernetes_service" "helm_ingress_existing" {
  count = var.enable_ssl == true && var.use_existing_ingress == true ? 1 : 0
  depends_on = [
    module.helm_ingress
  ]
  metadata {
    name      = var.existing_ingress_name
    namespace = var.existing_ingress_namespace
  }
}

data "aws_elb" "helm_ingress_existing" {
  count = var.enable_ssl == true && var.use_existing_ingress == true ? 1 : 0
  depends_on = [
    data.kubernetes_service.helm_ingress_existing
  ]
  name = split("-", data.kubernetes_service.helm_ingress_existing[0].status.0.load_balancer.0.ingress.0.hostname)[0]
}

# If we are using an existing helm_ingress we'll still need to render a clusterissuer
# This is duplicated from the nginx-ingress module

data "template_file" "cluster_issuer" {
  count    = var.enable_ssl == true && var.render_cluster_issuer == true ? 1 : 0
  template = file(local.cluster_issuer_template)
  vars = {
    name              = trimspace(var.helm_release_name)
    letsencrypt_email = trimspace(var.letsencrypt_email)
  }
}

resource "local_file" "cluster_issuer" {
  count = var.enable_ssl == true && var.render_cluster_issuer ? 1 : 0
  depends_on = [
    data.template_file.cluster_issuer
  ]
  content  = data.template_file.cluster_issuer[0].rendered
  filename = "${var.helm_release_values_dir}/cluster-issuer.yaml"
}

resource "null_resource" "kubectl_apply_cluster_issuer" {
  count = var.enable_ssl == true && var.render_cluster_issuer == true ? 1 : 0
  depends_on = [
    local_file.cluster_issuer
  ]
  provisioner "local-exec" {
    command = <<EOT
     mkdir -p ${var.helm_release_values_dir}
     kubectl apply -f ${var.helm_release_values_dir}/cluster-issuer.yaml
     EOT
  }
}

# ########################################################
# # Get the ingress
# ########################################################

locals {
  kubernetes_service = var.enable_ssl == true && var.use_existing_ingress == true ? data.kubernetes_service.helm_ingress_existing : data.kubernetes_service.helm_ingress
  # if not using an ingress the aws_elb should point to the loadbalancer
  aws_elb = var.enable_ssl == true && var.use_existing_ingress == true ? data.aws_elb.helm_ingress_existing : data.aws_elb.helm_ingress
}


output "kubernetes_service" {
  value = local.kubernetes_service
}

output "aws_elb_ingress" {
  value = local.aws_elb
}

output "ingress_template" {
  value = local.ingress_template
}

# # TODO
# # Default uses a bitnami ingress setup. All bitnami charts use the same structure
# # Should check first if it's a bitnami chart, and if not warn
data "template_file" "ingress" {
  count    = var.enable_ssl == true && var.render_ingress ? 1 : 0
  template = file(local.ingress_template)
  vars = {
    helm_release_name       = var.helm_release_name
    aws_route53_record_name = var.aws_route53_record_name
    aws_route53_domain_name = trimsuffix(var.aws_route53_zone_name, ".")
    ingress_dns             = local.aws_elb[0].dns_name
    letsencrypt_email       = var.letsencrypt_email
  }
}

resource "local_file" "rendered_ingress" {
  count = var.enable_ssl == true && var.render_ingress ? 1 : 0
  depends_on = [
    data.template_file.ingress
  ]
  content  = data.template_file.ingress[0].rendered
  filename = "${var.helm_release_values_dir}/ingress.yaml"
}

locals {
  helm_release_values_files = tolist(distinct(
    compact(flatten([
      [
        [
          #TODO this fails if enable_ssl=false
          var.enable_ssl == true && var.render_ingress == true ? abspath(local_file.rendered_ingress[0].filename) : null,
        ],
        [for s in var.helm_release_values_files : abspath(s)],
      ]
    ]))
  ))
}

module "merge_values" {
  depends_on = [
    local_file.rendered_ingress,
    null_resource.create_merged_file
  ]
  source                          = "dabble-of-devops-biodeploy/merge-values/helm"
  version                         = ">= 0.2.0"
  context                         = module.this.context
  helm_values_dir                 = var.helm_release_values_dir
  helm_values_files               = local.helm_release_values_files
  helm_release_merged_values_file = local.helm_release_merged_values_file
}

# # TODO add in option for helm release vs rancher release
resource "helm_release" "helm" {
  depends_on = [
    module.merge_values,
  ]
  name             = var.helm_release_name
  repository       = var.helm_release_repository
  chart            = var.helm_release_chart
  version          = var.helm_release_version
  namespace        = var.helm_release_namespace
  create_namespace = var.helm_release_create_namespace
  wait             = var.helm_release_wait

  #TODO Caution against
  dynamic "set" {
    for_each = var.helm_release_sets
    content {
      name  = set.value["name"]
      value = set.value["value"]
      # must be one of auto or string
      type = set.value["type"] == "string" ? set.value["type"] : "auto"
    }
  }

  values = [file(local.helm_release_merged_values_file)]
}

output "helm_release" {
  value     = helm_release.helm
  sensitive = true
}

resource "null_resource" "sleep_helm_update" {
  depends_on = [
    helm_release.helm
  ]
  provisioner "local-exec" {
    command = <<EOT
    echo "Waiting for the helm service to come up"
    sleep 5m
    EOT
  }
}

# #########################################################################
# # AWS Route 53 Assign
# #########################################################################

data "aws_route53_zone" "helm" {
  count = var.enable_ssl == true ? 1 : 0
  name  = var.aws_route53_zone_name
}

output "aws_route53_zone_helm" {
  value = data.aws_route53_zone.helm
}

# #########################################################################
# # Helm Release Service Type == LoadBalancer
# #########################################################################

data "kubernetes_service" "load_balancer" {
  count = var.helm_release_values_service_type == "LoadBalancer" ? 1 : 0
  depends_on = [
    helm_release.helm,
    null_resource.sleep_helm_update
  ]
  metadata {
    name      = var.helm_release_name
    namespace = var.helm_release_namespace
  }
}

output "kubernetes_service_helm" {
  value = data.kubernetes_service.load_balancer
}

data "aws_elb" "load_balancer" {
  count = var.helm_release_values_service_type == "LoadBalancer" ? 1 : 0
  depends_on = [
    helm_release.helm,
    data.kubernetes_service.load_balancer,
  ]
  name = split("-", data.kubernetes_service.load_balancer[0].status.0.load_balancer.0.ingress.0.hostname)[0]
}

output "aws_elb_load_balancer" {
  value = data.aws_elb.load_balancer
}

resource "aws_route53_record" "load_balancer" {
  count = var.enable_ssl && var.helm_release_values_service_type == "LoadBalancer" ? 1 : 0
  depends_on = [
    module.helm_ingress,
    helm_release.helm,
  ]
  zone_id = data.aws_route53_zone.helm[0].zone_id
  name    = var.aws_route53_record_name
  type    = "A"
  alias {
    name                   = data.aws_elb.load_balancer[0].dns_name
    zone_id                = data.aws_elb.load_balancer[0].zone_id
    evaluate_target_health = true
  }
}

output "aws_route53_record_load_balancer" {
  value = aws_route53_record.load_balancer
}

#########################################################################
# Helm Release Service Type
# helm_release_values_service_type == ClusterIP and var.enable_ssl = true
#########################################################################

resource "aws_route53_record" "cluster_ip" {
  count = var.enable_ssl && var.helm_release_values_service_type == "ClusterIP" ? 1 : 0
  depends_on = [
    module.helm_ingress,
    helm_release.helm,
  ]
  zone_id = data.aws_route53_zone.helm[0].zone_id
  name    = var.aws_route53_record_name
  type    = "A"
  alias {
    name                   = local.aws_elb[0].dns_name
    zone_id                = local.aws_elb[0].zone_id
    evaluate_target_health = true
  }
}

output "aws_route53_record_cluster_ip" {
  value = aws_route53_record.cluster_ip
}

locals {
  ssl_type = var.enable_ssl && var.helm_release_values_service_type == "ClusterIP" ? "cluster_ip" : "load_balancer"
  dns_record = var.enable_ssl && var.helm_release_values_service_type == "ClusterIP" ? aws_route53_record.cluster_ip : aws_route53_record.load_balancer
}

output "ssl_type" {
  value = local.ssl_type
}