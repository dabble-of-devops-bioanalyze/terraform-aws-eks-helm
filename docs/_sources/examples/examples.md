# Examples

This directory contains the examples for installing applications on AWS EKS using a [Helm chart](https://helm.sh/), the package manager for Kubernetes.

The examples are meant to give some common scenarios for using the main module. Most commonly you will not use this module on it's own, but will instead use modules that call this module. They do not cover every use case. If you think a module should have a particular example please reach out and request an example on [github](https://github.com/dabble-of-devops-bioanalyze/terraform-aws-eks-helm) by creating an issue.

## AWS EKS - NGINX installation with SSL

The `nginx` example deploys an [NGINX](https://github.com/bitnami/charts/tree/master/bitnami/nginx) helm chart as an example. Although this is demonstrated as an example, it is always a good idea to install NGINX. It is the simplest web application to get up and running, and if it doesn't install you probably have other problems.

## More Tutorials Coming Up

We understand that managing DNS is not why you became a scientist! BioAnalyze is aiming to make this as simple as possible. There will be more tutorials coming up.