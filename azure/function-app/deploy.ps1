#!/usr/bin/env pwsh

# This script creates a resource group and then creates an Azure Flex Consumption Function.
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
    [string]$FunctionName,

    [Parameter(Mandatory=$false)]
    [string]$HostingPlanName,

    [Parameter(Mandatory=$false)]
    [string]$StorageAccountName
)

if (-not $RgName) {
    $RgName = "octopub-function-${Environment}"
}

if (-not $FunctionName) {
    $FunctionName = "octopub-function-${Environment}"
}

if (-not $HostingPlanName) {
    $HostingPlanName = "ASP-${FunctionName}"
}

# Must be lowercase letters and number only, between 3 and 24 characters
if (-not $StorageAccountName) {
    $tempName = "octopubfunction${Environment}".ToLower()
    $StorageAccountName = $tempName.SubString(0, [Math]::Min(24, $tempName.Length))
}

# Check if resource group exists
$rgExists = az group exists --name $RgName | ConvertFrom-Json

if (-not $rgExists) {
    Write-Host "Resource group ${RgName} does not exist. Creating..."

    # Start by creating the resource group
    az deployment sub create `
        --location $Region `
        --template-file ../resource-group/template.json `
        --parameters ../resource-group/parameters.json `
        --parameters `
        rgName=$RgName

    # Then deploy the function app and hosting plan into the resource group
    az deployment group create `
        --resource-group $RgName `
        --template-file template.json `
        --parameters parameters.json `
        --parameters `
        environment=$Environment `
        resourceGroup=$RgName `
        name=$FunctionName `
        hostingPlanName=$HostingPlanName `
        location=$Region `
        storageAccountName=$StorageAccountName `
        storageBlobContainerName=$FunctionName

    Write-Host "Resource group ${RgName} created and function app ${FunctionName} deployed successfully."
} else {
    Write-Host "Resource group ${RgName} already exists. Skipping creation."
}

