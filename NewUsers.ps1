if (Get-Module -ListAvailable -Name BcContainerHelper) {
    Import-Module BcContainerHelper
} 
else {
    Get-Module BcContainerHelper
}

$users = Import-CSV -path "C:\Folder\User.csv"
$Container = "ContainerName"

foreach ($user in $users)
{
   $credential = $user.'Credential'
   $PermissionSet = $User.'PermissionSet'
  
New-BcContainerBcUser -containerName $Container -Credential $credential -assignPremiumPlan -PermissonsetId $PermissionSet
}