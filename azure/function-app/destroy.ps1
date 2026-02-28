#!/usr/bin/env pwsh

# This script deletes the resource group and all resources created by deploy.ps1.
# Call like this:
# ./destroy.ps1 -Environment production

param(
    [Parameter(Mandatory=$false)]
    [string]$Environment = "development",

    [Parameter(Mandatory=$false)]
    [string]$RgName
)

if (-not $RgName) {
    $RgName = "octopub-function-${Environment}"
}

# Check if resource group exists
$rgExists = az group exists --name $RgName | ConvertFrom-Json

if ($rgExists) {
    Write-Host "Resource group ${RgName} exists. Deleting..."
    Start-Sleep -Seconds 5

    az group delete --name $RgName --yes --no-wait

    Write-Host "Resource group ${RgName} deletion initiated. This may take several minutes to complete."
} else {
    Write-Host "Resource group ${RgName} does not exist. Nothing to delete."
}

