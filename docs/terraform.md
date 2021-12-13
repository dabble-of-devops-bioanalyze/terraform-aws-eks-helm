<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.30.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.1.2 |
| <a name="requirement_http"></a> [http](#requirement\_http) | >= 2.1.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.5.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 1.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.68.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.4.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.7.1 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.1.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_merge_values"></a> [merge\_values](#module\_merge\_values) | dabble-of-devops-biodeploy/merge-values/helm | >= 0.2.0 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.cluster_ip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.load_balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [helm_release.helm](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [local_file.cluster_issuer](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.rendered_ingress](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.create_merged_file](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.helm_dirs](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.kubectl_apply_cluster_issuer](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.sleep_helm_update](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_string.computed_values](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_elb.load_balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb) | data source |
| [kubernetes_service.load_balancer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |
| [template_file.cluster_issuer](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.ingress](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_aws_elb_dns_name"></a> [aws\_elb\_dns\_name](#input\_aws\_elb\_dns\_name) | Pass in the aws\_elb ingress here | `string` | `""` | no |
| <a name="input_aws_elb_zone_id"></a> [aws\_elb\_zone\_id](#input\_aws\_elb\_zone\_id) | Pass in the aws\_elb ingress here | `any` | `""` | no |
| <a name="input_aws_route53_record_name"></a> [aws\_route53\_record\_name](#input\_aws\_route53\_record\_name) | Record name to add to aws\_route\_53. Must be a valid subdomain - www,app,etc | `string` | `"www"` | no |
| <a name="input_aws_route53_zone_id"></a> [aws\_route53\_zone\_id](#input\_aws\_route53\_zone\_id) | Pass in the aws\_elb ingress here | `string` | `""` | no |
| <a name="input_aws_route53_zone_name"></a> [aws\_route53\_zone\_name](#input\_aws\_route53\_zone\_name) | Name of the zone to add records. Do not forget the trailing '.' - 'test.com.' | `string` | `"test.com."` | no |
| <a name="input_cluster_issuer_template"></a> [cluster\_issuer\_template](#input\_cluster\_issuer\_template) | Path to cluster issuer template. Default cluster issuer is supplied. | `string` | `""` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_enable_ssl"></a> [enable\_ssl](#input\_enable\_ssl) | Enable SSL Support? | `bool` | `true` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_existing_ingress_name"></a> [existing\_ingress\_name](#input\_existing\_ingress\_name) | Existing ingress release name | `string` | `"nginx-ingress-ingress-nginx-ingress-controller"` | no |
| <a name="input_existing_ingress_namespace"></a> [existing\_ingress\_namespace](#input\_existing\_ingress\_namespace) | Existing ingress release namespace | `string` | `"default"` | no |
| <a name="input_helm_release_chart"></a> [helm\_release\_chart](#input\_helm\_release\_chart) | helm release chart | `string` | `"airflow"` | no |
| <a name="input_helm_release_create_namespace"></a> [helm\_release\_create\_namespace](#input\_helm\_release\_create\_namespace) | Create namespace if it does not exist | `bool` | `true` | no |
| <a name="input_helm_release_merged_values_file"></a> [helm\_release\_merged\_values\_file](#input\_helm\_release\_merged\_values\_file) | Path to merged helm files. If blank one will be calculated for you. | `string` | `""` | no |
| <a name="input_helm_release_name"></a> [helm\_release\_name](#input\_helm\_release\_name) | helm release name | `string` | `"helm"` | no |
| <a name="input_helm_release_namespace"></a> [helm\_release\_namespace](#input\_helm\_release\_namespace) | helm release namespace | `string` | `"default"` | no |
| <a name="input_helm_release_repository"></a> [helm\_release\_repository](#input\_helm\_release\_repository) | helm release chart repository | `string` | `"https://charts.bitnami.com/bitnami"` | no |
| <a name="input_helm_release_sets"></a> [helm\_release\_sets](#input\_helm\_release\_sets) | Variable sets | `list(object({ name = string, value = string, type = string }))` | `[]` | no |
| <a name="input_helm_release_values_dir"></a> [helm\_release\_values\_dir](#input\_helm\_release\_values\_dir) | Directory to put rendered values template files or additional keys. Should be helm\_charts/{helm\_release\_name} | `string` | `"helm_charts"` | no |
| <a name="input_helm_release_values_files"></a> [helm\_release\_values\_files](#input\_helm\_release\_values\_files) | helm release values files - paths values files to add to helm install --values {} | `list(string)` | `[]` | no |
| <a name="input_helm_release_values_service_type"></a> [helm\_release\_values\_service\_type](#input\_helm\_release\_values\_service\_type) | Service type. Must be one of LoadBalancer or ClusterIP. If using enable\_ssl=true the service type should be ClusterIP | `string` | `"ClusterIP"` | no |
| <a name="input_helm_release_version"></a> [helm\_release\_version](#input\_helm\_release\_version) | helm release version | `string` | `"11.0.8"` | no |
| <a name="input_helm_release_wait"></a> [helm\_release\_wait](#input\_helm\_release\_wait) | Tell terraform to wait until the service comes up. | `bool` | `true` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_ingress_template"></a> [ingress\_template](#input\_ingress\_template) | Path to ingress template. Ingress compatible with bitnami is given. | `string` | `""` | no |
| <a name="input_install_ingress"></a> [install\_ingress](#input\_install\_ingress) | Deprecated: Install the ingress helm chart. No will only fill out the cluster issuer, yes fills out the cluster issuer and installs. | `bool` | `true` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_letsencrypt_email"></a> [letsencrypt\_email](#input\_letsencrypt\_email) | Email to use for https setup. Not needed unless enable\_ssl | `string` | `"hello@gmail.com"` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"us-east-1"` | no |
| <a name="input_render_cluster_issuer"></a> [render\_cluster\_issuer](#input\_render\_cluster\_issuer) | Create a cluster-issuer.yaml file | `bool` | `true` | no |
| <a name="input_render_ingress"></a> [render\_ingress](#input\_render\_ingress) | Render ingress.yaml file - only useful if installing an additional service such as nginx | `bool` | `true` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| <a name="input_use_existing_ingress"></a> [use\_existing\_ingress](#input\_use\_existing\_ingress) | Use existing ingress | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_elb_load_balancer"></a> [aws\_elb\_load\_balancer](#output\_aws\_elb\_load\_balancer) | n/a |
| <a name="output_aws_route53_record_cluster_ip"></a> [aws\_route53\_record\_cluster\_ip](#output\_aws\_route53\_record\_cluster\_ip) | n/a |
| <a name="output_aws_route53_record_load_balancer"></a> [aws\_route53\_record\_load\_balancer](#output\_aws\_route53\_record\_load\_balancer) | n/a |
| <a name="output_helm_release"></a> [helm\_release](#output\_helm\_release) | n/a |
| <a name="output_id"></a> [id](#output\_id) | ID of the created example |
| <a name="output_kubernetes_service_helm"></a> [kubernetes\_service\_helm](#output\_kubernetes\_service\_helm) | n/a |
| <a name="output_ssl_type"></a> [ssl\_type](#output\_ssl\_type) | n/a |
<!-- markdownlint-restore -->
