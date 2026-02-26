#!/bin/bash

# This script creates a resource group and then creates an Azure Flex Consumption Function.
# Call like this:
# ./deploy.sh production

# Web app names must be globally unique. Resource group names also need to be unique.
# So we generate a random suffix to append to the names to avoid conflicts with existing resources in the subscription.
RANDOM_SUFFIX=$(openssl rand -hex 5)

# Set the variables for the deployment. You can override these by passing in parameters when you run the script,
# or just let it generate unique names for you.
ENVIRONMENT=${1:-"development"}
RANDOM_SUFFIX_SUPPLIED=${2:-$RANDOM_SUFFIX}
REGION=${3:-"australiaeast"}
RG_NAME=${4:-"octopub-${ENVIRONMENT}-${RANDOM_SUFFIX_SUPPLIED}"}
FUNCTION_NAME=${5:-"octopub-function-${ENVIRONMENT}-${RANDOM_SUFFIX_SUPPLIED}"}
HOSTING_PLAN_NAME=${6:-"ASP-${FUNCTION_NAME}"}
# Must be lowercase letters and number only, between 3 and 24 characters
STORAGE_ACCOUNT_NAME=${7:-"${ENVIRONMENT}${RANDOM_SUFFIX_SUPPLIED}"}

if az group exists --name "${RG_NAME}" | grep -q "false"; then
  # Start by creating the resource group
  az deployment sub create \
    --location "${REGION}" \
    --template-file ../resource-group/template.json \
    --parameters ../resource-group/parameters.json \
    --parameters rgName="${RG_NAME}"

  # Then deploy the web app and hosting plan into the resource group
  az deployment group create \
    --resource-group "${RG_NAME}" \
    --template-file template.json \
    --parameters parameters.json \
    --parameters \
    environment="${ENVIRONMENT}" \
    resourceGroup="${RG_NAME}" \
    name="${FUNCTION_NAME}" \
    hostingPlanName="${HOSTING_PLAN_NAME}" \
    location="${REGION}" \
    storageAccountName="${STORAGE_ACCOUNT_NAME}" \
    storageBlobContainerName="${FUNCTION_NAME}"
else
  echo "Resource group ${RG_NAME} already exists. Skipping creation."
fi