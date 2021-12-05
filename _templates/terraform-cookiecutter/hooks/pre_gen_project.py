import re
import sys

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

from pprint import pprint

cookiecutter_context = {{ cookiecutter.__dict__ }}
keys = cookiecutter_context.keys()
pprint(cookiecutter_context)