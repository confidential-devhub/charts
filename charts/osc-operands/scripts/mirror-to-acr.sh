#!/bin/bash
# Mirror images to Azure Container Registry for airgapped OSC deployment
#
# Prerequisites:
#   - yq and skopeo installed
#   - Logged into source registries: podman login registry.redhat.io
#   - Logged into ACR: az acr login -n <acr-name> OR podman login <acr>.azurecr.io
#
# Usage: ./mirror-to-acr.sh <values.yaml>
#
# Reads registry and images from values file (airgap.registry and airgap.images)
#
# To login to ACR with az cli:
#   ACR_TOKEN=$(az acr login -n <acr-name> --expose-token --query accessToken -o tsv)
#   podman login <acr>.azurecr.io -u 00000000-0000-0000-0000-000000000000 -p "$ACR_TOKEN"

set -euo pipefail

VALUES_FILE="${1:-}"
[[ -z "$VALUES_FILE" ]] && echo "Usage: $0 <values.yaml>" && exit 1
[[ ! -f "$VALUES_FILE" ]] && echo "Error: $VALUES_FILE not found" && exit 1

REGISTRY=$(yq '.airgap.registry' "$VALUES_FILE")
[[ -z "$REGISTRY" || "$REGISTRY" == "null" ]] && echo "Error: airgap.registry not set" && exit 1

echo "Target registry: $REGISTRY"
echo ""

yq '.airgap.images[]' "$VALUES_FILE" | while read -r src; do
  name=$(echo "$src" | sed 's|.*/||' | sed 's|@.*||' | sed 's|:.*||')
  echo "Mirroring: $src -> ${REGISTRY}/${name}"
  skopeo copy --all "docker://${src}" "docker://${REGISTRY}/${name}"
done

echo ""
echo "Done."
