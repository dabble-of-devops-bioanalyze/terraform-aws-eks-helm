apiVersion: cert-manager.io/v1
#kind: ClusterIssuer
kind: Issuer
metadata:
  name: ${name}-letsencrypt
  labels:
    name: ${name}-letsencrypt
spec:
  acme:
    email: ${letsencrypt_email}
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    #server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: ${name}-letsencrypt
    solvers:
    - http01:
        ingress:
          class: "nginx"
