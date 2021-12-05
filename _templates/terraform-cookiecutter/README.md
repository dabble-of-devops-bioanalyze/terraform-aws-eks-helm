# Terraform Module Cookiecutter

This is a cookicutter template to create Terraform modules based on the [BioAnalyze](https://www.bioanalyze.io) terraform recipe examples.

We use the [CloudPosse](https://github.com/cloudposse/terraform-example-module) as a base, and the [Label](https://github.com/cloudposse/terraform-null-label) module to generate a name.


The name is generated as:

```
delimiter = '{{cookiecutter.delimiter}}'

label_order         = ["namespace", "environment", "stage", "name", "attributes"]
id_context = {
    "namespace" : "{{ cookiecutter.namespace}}",
    "tenant" : "{{cookiecutter.tenant}}",
    "name" : "{{ cookiecutter.name}}",
    "environment" : "{{cookiecutter.environment}}",
    "stage"       : "{{cookiecutter.stage}}",
    "name"       : "{{cookiecutter.name}}"
}

labels = []
for l in label_order:
    if l in id_context and l:
        labels.append(id_context[l])

id_full = delimiter.join(labels)

{{ cookiecutter.update({ "project_name": id_full }) }}
```


You do not need to include all the labels. Usually I only use namespace, environment, and stage.

```
namespace = "bioanalyze"
environment = "eks"
stage = "dev"
```

Would result in the project name `bioanalyze-eks-dev`. 

Before you start creating multiple projects it's recommended that you document your naming convention.
