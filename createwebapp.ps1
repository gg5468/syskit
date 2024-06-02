param(
    [Parameter(Mandatory)] [string] $resourceGroupName,
    [Parameter(Mandatory)] [string] $webAppPlanName,
    [Parameter(Mandatory)] [string] $webAppName
)
Install-Module -Name Az -Repository PSGallery #-Force
Connect-AzAccount
New-AzWebApp -ResourceGroupName $resourceGroupName -Name $webAppName -AppServicePlan $webAppPlanName
 