# Readme

Apply the secret from your local file system to the Kubernetes cluster, first:

```bash
helm template . \
    --namespace=trustee-operator-system  \
    --values values.yaml \
    --values values-secret.yaml \
    | yq 'select(.kind == "Secret" or .kind == "Namespace")'
```
