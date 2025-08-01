#!/bin/bash
#
# source utils/gcp-get-values.sh
#
# The following values are going to be set, from infrastructure cluster object:
#  - GCP_PROJECT_ID
#  - GCP_REGION
#  - GCP_NETWORK

WORKERNODE="$(oc get nodes | grep worker | head -1 | cut -d\   -f1)"
#export GCP_PROJECT_ID=$(oc get infrastructure cluster -o json | jq -r '.status.platformStatus.gcp.projectID')
export GCP_PROJECT_ID="it-cloud-gcp-prod-osc-devel"
#export GCP_REGION=$(oc get infrastructure cluster -o json | jq -r '.status.platformStatus.gcp.region')
export GCP_REGION="us-central1"
#export GCP_NETWORK=$(oc get machine -n openshift-machine-api -o jsonpath="{.items[?(@.metadata.name=='${WORKERNODE}')].spec.providerSpec.value.networkInterfaces[0].network}")
export GCP_NETWORK="default"
export GCP_MACHINE_TYPE="e2-medium" # or any other
export PODVM_IMAGE_NAME="podvm-image-2025033151"
