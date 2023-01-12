# BC_Container
BC Container is a collection of Powershell scripts to allow quick and easy setup of a docker desktop container of Dynamics BC

# Script Discriptions
## ContainerBuild.ps1
Download & load BCContainerhelper powershell module, download & load Powershellget module. Set veriable for the name of the powershell container. Then download the newest objects set up and build the container. This uses the BCContainerHelper module. 

## DockerDesktopInstaller.ps1
Depreciated and only left for humility reasons.

## DownloadDocker.ps1
**Requires Admin to run**. Enables Hyper-V (may require reboot) Runs a webrequest to download the Dockerdesktop windows isntaller and executes the exe. Add's currently logged in user to the docker user group. Pop's open a reboot window that wil ltrigger a reboot if no selection made.

## Extension_Installer.ps1


## Script Order
DownloadDocker.ps1
ContainerBuild.ps1
NewUsers.ps1 (If needed)
Extension_Install.ps1 (If needed)

###### Depreciated Scripts
DockerDesktopInstaller.ps1

###### To Do's
Combine all scripts into one build
Build scripts to remove container, update the objects reinstall using the newest version --add reminder to export info using config packages
Find a good way to check the URL for dockerdownload is still up and running. 
