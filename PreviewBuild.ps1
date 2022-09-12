#Check if BcContainerHelper module is installed & load it. Download & load if not yet installed. 
if (Get-Module -ListAvailable -Name BcContainerHelper) {
    Write-Output "Loading BcContainerHelper"
    Import-Module BcContainerHelper
} 
else {
    Write-Output "BcContainerHelper Missing, intalling now"
    Install-Module -Name BcContainerHelper
    Import-Module BcContainerHelper
}
$CTName = "Preview"
#Get latest verions of BC artifacts & mount container
$artifactUrl = Get-BcArtifactUrl -storageAccount BcPublicPreview -country US
New-BCContainer -accept_eula -containerName $CTName -assignPremiumPlan -artifactUrl $artifactUrl -multitenant:$false -Credential $credential -auth UserPassword ` -updatHosts