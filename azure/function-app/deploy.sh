#!/bin/bash

# This script creates a resource group and then creates an Azure Flex Consumption Function.
# Call like this:
# ./deploy.sh production

# Set the variables for the deployment. You can override these by passing in parameters when you run the script,
# or just let it generate unique names for you.
ENVIRONMENT=${1:-"development"}
REGION=${2:-"australiaeast"}
RG_NAME=${3:-"octopub-function-${ENVIRONMENT}"}
FUNCTION_NAME=${4:-"octopub-function-${ENVIRONMENT}"}
HOSTING_PLAN_NAME=${5:-"ASP-${FUNCTION_NAME}"}
# Must be lowercase letters and number only, between 3 and 24 characters
STORAGE_ACCOUNT_NAME=${6:-"octopubfunction${ENVIRONMENT}"}
STORAGE_ACCOUNT_NAME="${STORAGE_ACCOUNT_NAME:0:24}"

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

    echo "Resource group ${RG_NAME} created and function app ${FUNCTION_NAME} deployed successfully."
else
  echo "Resource group ${RG_NAME} already exists. Skipping creation."
fi