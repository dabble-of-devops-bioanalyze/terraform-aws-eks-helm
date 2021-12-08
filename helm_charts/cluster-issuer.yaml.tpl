apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: ${name}-letsencrypt
  labels:
    name: ${name}-letsencrypt
spec:
  acme:
    email: ${letsencrypt_email}
    privateKeySecretRef:
      name: ${name}-letsencrypt
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
    - http01:
        ingress:
          class: "nginx"