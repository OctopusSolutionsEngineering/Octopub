#!/bin/bash

RANDOM_SUFFIX=$(openssl rand -hex 5)

REGION=${1:-"australiaeast"}
RG_NAME=${2:-"octopub"}
WEBAPP_NAME=${3:-"octopub-${RANDOM_SUFFIX}"}
HOSTING_PLAN_NAME=${4:-"ASP-${WEBAPP_NAME}"}

az deployment sub create \
  --location ${REGION} \
  --template-file ../resource-group/template.json \
  --parameters ../resource-group/parameters.json \
  --parameters rgName=${RG_NAME}

az deployment group create \
  --resource-group ${RG_NAME} \
  --template-file template.json \
  --parameters parameters.json \
  --parameters resourceGroupName=${RG_NAME} name=${WEBAPP_NAME} hostingPlanName=${HOSTING_PLAN_NAME} location=${REGION}