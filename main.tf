#######################################################
# terraform-aws-eks-helm
#######################################################

locals {
  ingress_template = length(var.ingress_template) > 0 ? var.ingress_template : "${path.module}/helm_charts/bitnami/ingress.yaml.tpl"
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
  provisioner "local-exec" {
    command = <<EOT
    mkdir -p ${var.helm_release_values_dir}
    touch ${local.helm_release_merged_values_file}
    touch ${var.helm_release_values_dir}/ingress.yaml
    EOT
  }
}

# #################################################################
# https://cert-manager.io/docs/release-notes/release-notes-0.11/
# #################################################################

resource "kubernetes_manifest" "letsencrypt" {
  count    = var.enable_ssl == true ? 1 : 0
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata"   = {
      "name" = "${var.helm_release_name}-letsencrypt"
    }
    "spec" = {
      "acme" = {
        "email"               = var.letsencrypt_email
        "privateKeySecretRef" = {
          "name" = "${var.helm_release_name}-letsencrypt"
        }
        "server"  = "https://acme-v02.api.letsencrypt.org/directory"
        "solvers" = [
          {
            "http01" = {
              "ingress" = {
                "class" = "nginx"
              }
            }
          },
        ]
      }
    }
  }
}

#########################################################
## Generate Ingress
#########################################################

data "template_file" "ingress" {
  count    = var.enable_ssl == true && var.render_ingress ? 1 : 0
  template = file(local.ingress_template)
  vars     = {
    helm_release_name       = var.helm_release_name
    aws_route53_record_name = var.aws_route53_record_name
    aws_route53_domain_name = trimsuffix(var.aws_route53_zone_name, ".")
    letsencrypt_email       = var.letsencrypt_email
  }
}

resource "local_file" "rendered_ingress" {
  count      = var.enable_ssl == true && var.render_ingress ? 1 : 0
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

resource "helm_release" "helm" {
  depends_on = [
    kubernetes_manifest.letsencrypt,
    module.merge_values,
  ]
  name             = var.helm_release_name
  repository       = var.helm_release_repository
  chart            = var.helm_release_chart
  version          = var.helm_release_version
  namespace        = var.helm_release_namespace
  create_namespace = var.helm_release_create_namespace
  wait             = var.helm_release_wait
  timeout          = 600

  values = [file(local.helm_release_merged_values_file)]
}

output "helm_release" {
  value     = helm_release.helm
  sensitive = true
}
