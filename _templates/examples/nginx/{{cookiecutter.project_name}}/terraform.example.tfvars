additional_tag_map             = {}
attributes                     = []
aws_availability_zones_exclude = []
aws_route53_record_name        = "www"
aws_route53_zone_name          = "test.com."
context = {
  "additional_tag_map": {},
  "attributes": [],
  "delimiter": null,
  "descriptor_formats": {},
  "enabled": true,
  "environment": null,
  "id_length_limit": null,
  "label_key_case": null,
  "label_order": [],
  "label_value_case": null,
  "labels_as_tags": [
    "unset"
  ],
  "name": null,
  "namespace": null,
  "regex_replace_chars": null,
  "stage": null,
  "tags": {},
  "tenant": null
}
delimiter          = ""
descriptor_formats = {}
eks_node_groups = [
  {
    "desired_size": 1,
    "disk_size": 50,
    "instance_types": [
      "t3a.medium",
      "t3a.large",
      "t3a.2xlarge",
      "m4.10xlarge"
    ],
    "max_size": 450,
    "min_size": 0,
    "name": "node-group-1"
  }
]
enable_ssl                      = true
enabled                         = ""
environment                     = ""
helm_release_chart              = "airflow"
helm_release_create_namespace   = true
helm_release_merged_values_file = ""
helm_release_name               = "helm"
helm_release_namespace          = "default"
helm_release_repository         = "https://charts.bitnami.com/bitnami"
helm_release_values_dir         = "helm_charts"
helm_release_values_files       = []
helm_release_version            = "11.0.8"
helm_release_wait               = true
id_length_limit                 = ""
label_key_case                  = ""
label_order                     = ""
label_value_case                = ""
labels_as_tags = [
  "default"
]
letsencrypt_email   = "hello@gmail.com"
name                = ""
namespace           = ""
regex_replace_chars = ""
region              = "us-east-1"
run_tests           = true
stage               = ""
tags                = {}
tenant              = ""
