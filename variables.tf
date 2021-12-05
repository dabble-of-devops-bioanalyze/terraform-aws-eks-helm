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
# AWS EKS - Kubernetes Cluster
# Most of the time we will just pass in a provider
##################################################

variable "eks_cluster_id" {
  description = "EKS Cluster Id - This cluster must exist."
  type        = string
}

variable "eks_cluster_oidc_issuer_url" {
  description = "URL to the oidc issuer. The cluster must have been created with :   oidc_provider_enabled = true"
  type        = string
}

##################################################
# Helm Release Variables
# corresponds to input to resource "helm_release"
##################################################

# name             = var.airflow_release_name
# repository       = "https://charts.bitnami.com/bitnami"
# chart            = "airflow"
# version          = "11.0.8"
# namespace        = var.airflow_namespace
# create_namespace = true
# wait             = false
# values = [file("helm_charts/airflow/values.yaml")]

variable "helm_release_name" {
  type        = string
  description = "helm release name"
}

variable "helm_release_repository" {
  type        = string
  description = "helm release chart repository"
}

variable "helm_release_chart" {
  type        = string
  description = "helm release chart"
}

variable "helm_release_namespace" {
  type        = string
  description = "helm release namespace"
  default     = "default"
}

variable "helm_release_version" {
  type        = string
  description = "helm release version"
}

variable "helm_release_wait" {
  type    = bool
  default = true
}

variable "helm_release_create_namespace" {
  type    = bool
  default = true
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
