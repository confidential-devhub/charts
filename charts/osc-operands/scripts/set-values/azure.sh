# Prepares environment variables for Azure PeerPods on OpenShift. Source this
# script to load values automatically.

#### Location ####
# The Resource Group where your OpenShift cluster is deployed.
# Change it, if you would like to deploy PeerPods in a different RG.
export AZURE_RESOURCE_GROUP=$(oc get infrastructure/cluster -o jsonpath='{.status.platformStatus.azure.resourceGroupName}')

# The region corresponding to your resource group.
export AZURE_REGION=$(az group show --resource-group ${AZURE_RESOURCE_GROUP} --query "location" --output tsv)

#### Networking ####
# By default, here is using the same VNet and worker node subnet for simplicity
# and direct connectivity.
# 
# If using a dedicated VNet or subnet for PeerPods to improve isolation:
#
# - Ensure outbound NAT is configured on the subnet.
# - If using a different VNet, configure VNet peering with your cluster network.

# VNet where PodVMs will attach.
export AZURE_VNET_NAME=$(az network nic list --resource-group ${AZURE_RESOURCE_GROUP} --query "[?contains(name, 'worker')].ipConfigurations[0].subnet.id" -o tsv | head -n1 | awk -F/ '{print $(NF-2)}')

# Subnet ID where PodVMs will attach.
export AZURE_SUBNET_ID=$(az network nic list --resource-group ${AZURE_RESOURCE_GROUP} --query "[?contains(name, 'worker')].ipConfigurations[0].subnet.id" -o tsv | head -n1)

# Define a custom NSG to attach to the Podvm' NIC.
export AZURE_NSG_ID=$(az network nsg list --resource-group ${AZURE_RESOURCE_GROUP} --query "[].{Id:id}" --output tsv)
