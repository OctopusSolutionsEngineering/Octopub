#!/bin/bash

# This script creates a resource group and then creates an Azure Web App.
# Call like this:
# ./deploy.sh production

# Set the variables for the deployment. You can override these by passing in parameters when you run the script,
# or just let it generate unique names for you.
ENVIRONMENT=${1:-"development"}
REGION=${2:-"australiaeast"}
RG_NAME=${3:-"octopub-webapp-${ENVIRONMENT}"}
WEBAPP_NAME=${4:-"octopub-webapp-${ENVIRONMENT}"}
HOSTING_PLAN_NAME=${5:-"ASP-${WEBAPP_NAME}"}

# Check if resource group exists, create it if it doesn't
if az group exists --name "${RG_NAME}" | grep -q "false"; then
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
    --parameters resourceGroupName="${RG_NAME}" name="${WEBAPP_NAME}" hostingPlanName="${HOSTING_PLAN_NAME}" location="${REGION}"

  echo "Resource group ${RG_NAME} created and web app ${WEBAPP_NAME} deployed successfully."
else
  echo "Resource group ${RG_NAME} already exists. Skipping creation."
fi

