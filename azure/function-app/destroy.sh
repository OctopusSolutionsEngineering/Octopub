#!/bin/bash

# This script deletes the resource group and all resources created by deploy.sh.
# Call like this:
# ./destroy.sh production

# Function app names must be globally unique. Resource group names also need to be unique.
# So we generate a suffix based on the date of the previous Monday to append to the names.
# This provides consistency for resources created in the same week.
RANDOM_SUFFIX=$(date -d "last Monday" +%Y%m%d 2>/dev/null || date -v-Mon +%Y%m%d)

# Set the variables to match what deploy.sh would have created
ENVIRONMENT=${1:-"development"}
RANDOM_SUFFIX_SUPPLIED=${2:-$RANDOM_SUFFIX}
RG_NAME=${3:-"octopub-function-${ENVIRONMENT}-${RANDOM_SUFFIX_SUPPLIED}"}

# Check if resource group exists
if az group exists --name "${RG_NAME}" | grep -q "true"; then
  echo "Resource group ${RG_NAME} exists. Deleting..."
  echo "WARNING: This will delete all resources in the resource group ${RG_NAME}."
  echo "Press Ctrl+C within 5 seconds to cancel..."
  sleep 5

  az group delete --name "${RG_NAME}" --yes --no-wait

  echo "Resource group ${RG_NAME} deletion initiated. This may take several minutes to complete."
else
  echo "Resource group ${RG_NAME} does not exist. Nothing to delete."
fi

