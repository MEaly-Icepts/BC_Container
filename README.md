# BC_Container
BC Container is a collection of Powershell scripts to allow quick and easy setup of a docker desktop container of the Dynamics BC

## Scripts 
[DockerInstall.ps1](https://github.com/MEaly-Icepts/BC_Container/blob/master/DockerInstall.ps1) *Must be run as admin*  

Run this script first if Docker is not yet installed and configured. This script will install the Docker Desktop application and configure the windows prerequisites to run a windows based container. *Need to switch to windows mode manually right now, still need to correct that in the script*

[Build.ps1](https://github.com/MEaly-Icepts/BC_Container/blob/master/Build.ps1) *Remember to set the variable for the container name*

Run this script to download the newest BC artifacts in single tenant mode. *Can be altered to download any version of BC artifacts*

