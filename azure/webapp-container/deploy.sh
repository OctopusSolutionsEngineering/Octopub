#!/bin/bash

# This script creates a resource group and then creates an Azure Web App.
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
WEBAPP_NAME=${5:-"octopub-webapp-${ENVIRONMENT}-${RANDOM_SUFFIX_SUPPLIED}"}
HOSTING_PLAN_NAME=${6:-"ASP-${WEBAPP_NAME}"}

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
  --parameters resourceGroupName="${RG_NAME}" name="${WEBAPP_NAME}" hostingPlanName="${HOSTING_PLAN_NAME}" location="${REGION}"