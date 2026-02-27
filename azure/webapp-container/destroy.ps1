#!/usr/bin/env pwsh

# This script deletes the resource group and all resources created by deploy.ps1.
# Call like this:
# ./destroy.ps1 -Environment production

param(
    [Parameter(Mandatory=$false)]
    [string]$Environment = "development",

    [Parameter(Mandatory=$false)]
    [string]$RandomSuffixSupplied,

    [Parameter(Mandatory=$false)]
    [string]$RgName
)

# Function to get the previous Monday date
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

# Set the variables to match what deploy.ps1 would have created
if (-not $RandomSuffixSupplied) {
    $RandomSuffixSupplied = $RandomSuffix
}

if (-not $RgName) {
    $RgName = "octopub-function-${Environment}-${RandomSuffixSupplied}"
}

# Check if resource group exists
$rgExists = az group exists --name $RgName | ConvertFrom-Json

if ($rgExists) {
    Write-Host "Resource group ${RgName} exists. Deleting..."
    Write-Warning "This will delete all resources in the resource group ${RgName}. Press Ctrl+C to cancel."
    Start-Sleep -Seconds 5

    az group delete --name $RgName --yes --no-wait

    Write-Host "Resource group ${RgName} deletion initiated. This may take several minutes to complete."
} else {
    Write-Host "Resource group ${RgName} does not exist. Nothing to delete."
}

