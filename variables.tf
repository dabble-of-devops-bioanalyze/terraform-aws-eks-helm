##################################################
# Variables
# This file has various groupings of variables
##################################################

##################################################
# AWS
##################################################

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region"
}

##################################################
# AWS EKS
##################################################

##################################################
# Helm Release Variables
# corresponds to input to resource "helm_release"
##################################################

# name             = var.helm_release_name
# repository       = "https://charts.bitnami.com/bitnami"
# chart            = "helm"
# version          = "11.0.8"
# namespace        = var.helm_namespace
# create_namespace = true
# wait             = false
# values = [file("helm_charts/helm/values.yaml")]

variable "helm_release_name" {
  type        = string
  description = "helm release name"
  default     = "helm"
}

variable "helm_release_repository" {
  type        = string
  description = "helm release chart repository"
  default     = "https://charts.bitnami.com/bitnami"
}

variable "helm_release_chart" {
  type        = string
  description = "helm release chart"
  default     = "airflow"
}

variable "helm_release_namespace" {
  type        = string
  description = "helm release namespace"
  default     = "default"
}

variable "helm_release_version" {
  type        = string
  description = "helm release version"
  default     = "11.0.8"
}

variable "helm_release_wait" {
  description = "Tell terraform to wait until the service comes up."
  type        = bool
  default     = true
}

variable "helm_release_create_namespace" {
  description = "Create namespace if it does not exist"
  type        = bool
  default     = true
}

variable "helm_release_values_dir" {
  type        = string
  description = "Directory to put rendered values template files or additional keys. Should be helm_charts/{helm_release_name}"
  default     = "helm_charts"
}

variable "helm_release_values_files" {
  type        = list(string)
  description = "helm release values files - paths values files to add to helm install --values {}"
  default     = []
}

variable "helm_release_sets" {
  type        = list(object({ name = string, value = string, type = string }))
  description = "Variable sets"
  default     = []
}

variable "helm_release_merged_values_file" {
  type        = string
  description = "Path to merged helm files. If blank one will be calculated for you."
  default     = ""
}

variable "helm_release_values_service_type" {
  type        = string
  description = "Service type. Must be one of LoadBalancer or ClusterIP. If using enable_ssl=true the service type should be ClusterIP"
  default     = "ClusterIP"
}

##################################################
# Helm Release Variables - Enable SSL
# corresponds to input to resource "helm_release"
##################################################

variable "enable_ssl" {
  description = "Enable SSL Support?"
  type        = bool
  default     = true
}

# these variables are only needed if enable_ssl == true

variable "letsencrypt_email" {
  type        = string
  description = "Email to use for https setup. Not needed unless enable_ssl"
  default     = "hello@gmail.com"
}

variable "aws_route53_zone_name" {
  type        = string
  description = "Name of the zone to add records. Do not forget the trailing '.' - 'test.com.'"
  default     = "test.com."
}

variable "aws_route53_record_name" {
  type        = string
  description = "Record name to add to aws_route_53. Must be a valid subdomain - www,app,etc"
  default     = "www"
}

variable "ingress_template" {
  type        = string
  description = "Path to ingress template. Ingress compatible with bitnami is given."
  default     = ""
}

variable "cluster_issuer_template" {
  type        = string
  description = "Path to cluster issuer template. Default cluster issuer is supplied."
  default     = ""
}

variable "install_ingress" {
  type        = bool
  description = "Deprecated: Install the ingress helm chart. No will only fill out the cluster issuer, yes fills out the cluster issuer and installs. "
  default     = true
}

variable "use_existing_ingress" {
  type        = bool
  description = "Use existing ingress"
  default     = false
}

variable "render_ingress" {
  type        = bool
  default     = true
  description = "Render ingress.yaml file - only useful if installing an additional service such as nginx"
}

variable "render_cluster_issuer" {
  type        = bool
  description = "Create a cluster-issuer.yaml file"
  default     = true
}

variable "existing_ingress_name" {
  type        = string
  description = "Existing ingress release name"
  default     = "nginx-ingress-ingress-nginx-ingress-controller"
}

variable "existing_ingress_namespace" {
  type        = string
  description = "Existing ingress release namespace"
  default     = "default"
}

variable "aws_route53_zone_id" {
  type = string
  description = "Pass in the aws_elb ingress here"
  default = ""
}

variable "aws_elb_dns_name" {
  type = string
  description = "Pass in the aws_elb ingress here"
  default = ""
}

variable "aws_elb_zone_id" {
  type = any
  description = "Pass in the aws_elb ingress here"
  default = ""
}