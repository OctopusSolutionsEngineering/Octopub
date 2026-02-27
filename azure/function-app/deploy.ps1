#!/usr/bin/env pwsh

# This script creates a resource group and then creates an Azure Flex Consumption Function.
# Call like this:
# ./deploy.ps1 -Environment production

param(
    [Parameter(Mandatory=$false)]
    [string]$Environment = "development",

    [Parameter(Mandatory=$false)]
    [string]$RandomSuffixSupplied,

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

# Function app names must be globally unique. Resource group names also need to be unique.
# So we generate a suffix based on the date of the previous Monday to append to the names.
# This provides consistency for resources created in the same week.
function Get-PreviousMonday {
    $today = Get-Date
    $dayOfWeek = [int]$today.DayOfWeek

    # Calculate days to subtract to get to previous Monday
    # Sunday = 0, Monday = 1, etc.
    if ($dayOfWeek -eq 0) {
        # Sunday
        $daysToSubtract = 6
    } elseif ($dayOfWeek -eq 1) {
        # Monday - get last Monday
        $daysToSubtract = 7
    } else {
        # Tuesday-Saturday
        $daysToSubtract = $dayOfWeek - 1
    }

    $previousMonday = $today.AddDays(-$daysToSubtract)
    return $previousMonday.ToString("yyyyMMdd")
}

$RandomSuffix = Get-PreviousMonday

# Set the variables for the deployment. You can override these by passing in parameters when you run the script,
# or just let it generate unique names for you.
if (-not $RandomSuffixSupplied) {
    $RandomSuffixSupplied = $RandomSuffix
}

if (-not $RgName) {
    $RgName = "octopub-function-${Environment}-${RandomSuffixSupplied}"
}

if (-not $FunctionName) {
    $FunctionName = "octopub-function-${Environment}-${RandomSuffixSupplied}"
}

if (-not $HostingPlanName) {
    $HostingPlanName = "ASP-${FunctionName}"
}

# Must be lowercase letters and number only, between 3 and 24 characters
if (-not $StorageAccountName) {
    $StorageAccountName = "${Environment}${RandomSuffixSupplied}".ToLower()
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
        --parameters rgName=$RgName

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

