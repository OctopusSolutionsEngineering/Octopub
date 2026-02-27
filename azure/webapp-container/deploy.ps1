#!/usr/bin/env pwsh

# This script creates a resource group and then creates an Azure Web App.
# Call like this:
# ./deploy.ps1 -Environment production

param(
    [Parameter(Mandatory=$false)]
    [string]$Environment = "development",

    [Parameter(Mandatory=$false)]
    [string]$Region = "australiaeast",

    [Parameter(Mandatory=$false)]
    [string]$RgName,

    [Parameter(Mandatory=$false)]
    [string]$WebAppName,

    [Parameter(Mandatory=$false)]
    [string]$HostingPlanName
)

if (-not $RgName) {
    $RgName = "octopub-webapp-${Environment}"
}

if (-not $WebAppName) {
    $WebAppName = "octopub-webapp-${Environment}"
}

if (-not $HostingPlanName) {
    $HostingPlanName = "ASP-${WebAppName}"
}

# Check if resource group exists, create it if it doesn't
$rgExists = az group exists --name $RgName | ConvertFrom-Json

if (-not $rgExists) {
    Write-Host "Resource group ${RgName} does not exist. Creating..."

    az deployment sub create `
        --location $Region `
        --template-file ../resource-group/template.json `
        --parameters ../resource-group/parameters.json `
        --parameters rgName=$RgName

    # Then deploy the web app and hosting plan into the resource group
    az deployment group create `
        --resource-group $RgName `
        --template-file template.json `
        --parameters parameters.json `
        --parameters resourceGroupName=$RgName name=$WebAppName hostingPlanName=$HostingPlanName location=$Region

    Write-Host "Resource group ${RgName} created and web app ${WebAppName} deployed successfully."
} else {
    Write-Host "Resource group ${RgName} already exists. Skipping creation."
}

