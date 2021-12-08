# AWS EKS Helm Chart Installation - NGINX + Route53 DNS and SSL

This example shows how to install a helm chart application on AWS EKS. This chart assumes that you are using the AWS DNS service [Route53](https://aws.amazon.com/route53/), and if you are it will bootstrap all your DNS records for you. We *highly* recommend that you use a domain name on AWS, at least for development, with a wildcard [ACM](https://aws.amazon.com/certificate-manager/).

Please note that nearly every helm chart has it's own way of configuring SSL. There are 2 main ways of going about supplying SSL.

## SSL Configuration with an Ingress

This is the preferred method, as you can use a single Ingress to deploy multiple applications. Each LoadBalancer has it's own [cost](https://aws.amazon.com/elasticloadbalancing/pricing/), and if you only deploy 1 Load Balancer you will save money.

## SSL Configuration with a LoadBalancer

The second method is to deploy each application with a service type LoadBalancer.

```{include} ./quickstart.md
```


