param(
    [Parameter(Mandatory)] [string] $resourceGroupName,
    [Parameter(Mandatory)] [string] $webAppPlanName,
    [Parameter(Mandatory)] [string] $webAppName
)
Install-Module -Name Az -Repository PSGallery #-Force
Connect-AzAccount
New-AzWebApp -ResourceGroupName $resourceGroupName -Name $webAppName -AppServicePlan $webAppPlanName
$config = Get-AzResource -ResourceGroupName $resourceGroupName -ResourceType Microsoft.Web/sites/config -ResourceName $webAppName -ApiVersion 2023-12-01
$config.Properties.linuxFxVersion = "python|3.11"
$config | Set-AzResource -ApiVersion 2023-12-01 -Force