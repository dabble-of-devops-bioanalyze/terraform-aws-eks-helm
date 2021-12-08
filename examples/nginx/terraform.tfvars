# test region should always be us-east-2
region = "us-east-2"

namespace = "bioanalyze"

environment = "eks"

stage = "test"

#name = "terraform-aws-eks-helm-nginx"
name = "helm-nginx"

# Make sure to add the trailing .
aws_route53_zone_name = "bioanalyzedev.io."

helm_release_chart = "nginx"

letsencrypt_email = "jillian@dabbleofdevops.com"
# I'm going to be deploying 2 charts
#aws_route53_record_name = "nginx1"

#helm_release_values_dir = "helm_charts/nginx"

#helm_release_name = "nginx1"