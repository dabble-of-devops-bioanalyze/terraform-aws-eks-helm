## @section Airflow exposing parameters

## Configure the ingress resource that allows you to access the Airflow installation.
## ref: http://kubernetes.io/docs/user-guide/ingress/
## @param ingress.enabled Set to true to enable ingress record generation
## @param ingress.apiVersion Override API Version (automatically detected if not set)
## @param ingress.pathType Ingress Path type
## @param ingress.certManager Set this to true in order to add the corresponding annotations for cert-manager
## @param ingress.annotations Ingress annotations done as key:value pairs
## @param ingress.hosts The list of hostnames to be covered with this ingress record.
## @param ingress.secrets If you're providing your own certificates, use this to add the certificates as secrets
##

ingress:
  enabled: true
  tls: true
  apiVersion: ""
  pathType: ImplementationSpecific
  certManager: true
  hostname: ${aws_route53_record_name}.${aws_route53_domain_name}
  ## For a full list of possible ingress annotations, please see
  ## ref: https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md
  ##
  ## If tls is set to true, annotation ingress.kubernetes.io/secure-backends: "true" will automatically be set
  ## If certManager is set to true, annotation kubernetes.io/tls-acme: "true" will automatically be set
  ## Example:
  ## kubernetes.io/ingress.class: nginx
  ##
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: ${helm_release_name}-letsencrypt
    nginx.ingress.kubernetes.io/rewrite-target: /
  ## Most likely this will be just one host, but in the event more hosts are needed, this is an array
  ##
  extraHosts:
    - hosts:
        - ${aws_route53_record_name}.${aws_route53_domain_name}
      secretName: ${helm_release_name}.local-tls