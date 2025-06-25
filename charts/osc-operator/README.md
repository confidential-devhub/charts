# Install the helm

## GCP

```bash
source utils/gcp-get-values.sh
helm install \
  --set provider=gcp \
  --set gcp.GCP_PROJECT_ID=$GCP_PROJECT_ID  \
  --set gcp.GCP_ZONE=${GCP_REGION}-a \
  --set gcp.GCP_NETWORK=${GCP_NETWORK} \
  osc-operator .  \
  --wait
```

After the operator is installed, run again with the "upgrade" mode, to install
the `kataconfig`:

```bash
helm upgrade \
  --set provider=gcp \
  --set gcp.GCP_PROJECT_ID=$GCP_PROJECT_ID \
  --set gcp.GCP_ZONE=${GCP_REGION}-a \
  --set gcp.GCP_NETWORK=${GCP_NETWORK} \
  osc-operator .  \
  --wait
```
# Uninstall the helm

```bash
helm uninstall osc-operator
```

