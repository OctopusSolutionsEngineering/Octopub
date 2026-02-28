#!/bin/bash

# This script deletes the resource group and all resources created by deploy.sh.
# Call like this:
# ./destroy.sh production

# Set the variables to match what deploy.sh would have created
ENVIRONMENT=${1:-"development"}
RG_NAME=${2:-"octopub-function-${ENVIRONMENT}"}

# Check if resource group exists
if az group exists --name "${RG_NAME}" | grep -q "true"; then
  echo "Resource group ${RG_NAME} exists. Deleting..."

  az group delete --name "${RG_NAME}" --yes --no-wait

  echo "Resource group ${RG_NAME} deletion initiated. This may take several minutes to complete."
else
  echo "Resource group ${RG_NAME} does not exist. Nothing to delete."
fi

