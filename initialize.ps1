#Requires -RunAsAdministrator

# Preflight: Checking if all needed files are here
$RequiredFiles = @("mtkihvx2.dll","mtkwl6ex.inf","mtkwl6ex.sys","mtkwlan2.dat","installDriver.ps1")
$AllFilesPresent = $true

foreach ($File in $RequiredFiles) {
    $FilePath = Join-Path -Path $PSScriptRoot -ChildPath $File
    
    if (-not (Test-Path -Path $FilePath -PathType Leaf)) {
        Write-Warning "Missing required file: $File"
        $AllFilesPresent = $false
    }
}

# Stop if some file is missing
if (-not $AllFilesPresent) {
    Write-Error "Make sure all mtkwl6ex driver files and installDrive.ps1 are in the folder containing this script."
    return
}

# Preflight: Checking Secure Boot
$SecureBoot = Confirm-SecureBootUEFI

# Stop if Secure Boot is on
if ($SecureBoot -ne $false) {
    Write-Warning "Secure Boot must be disabled to continue. Disable it, then run this script again."
    exit
}

#Check Test Mode and enable it if off
$TestMode = (bcdedit | Select-String "testsigning").Line.Split()[-1]

if ($TestMode -eq "No") {
    Write-Host "Test Mode must be enabled to continue."
    Read-Host -Prompt "Press enter to allow this"
    bcdedit /set testsigning on
    Write-Host "Test Mode enabled. Restart, then run this script again." -ForegroundColor Green
    exit
}

#Workspace setup!!! Let's do this
mkdir ".\Workspace" | Out-Null
mkdir ".\Workspace\Output" | Out-Null
mkdir ".\Workspace\CatTemp" | Out-Null
Get-ChildItem -Path . -File | Copy-Item -Destination ".\Workspace\Output"

#Cleaning that workspace, probably a better way to do this but newbie coders code newbie code
del ".\Workspace\Output\installDriver.ps1"
del ".\Workspace\Output\initialize.ps1"
del ".\Workspace\Output\mtkwl6ex.cat"

#Finished

notepad ".\Workspace\Output\mtkwl6ex.inf"
Write-Host "Done! A Notepad window has opened now. You'll need to edit this yourself" -ForegroundColor Green
Write-Host "according to the instructions on GitHub." -ForegroundColor Green
Write-Host "Note the following:" -ForegroundColor Magenta
Get-PnpDevice | Where-Object { $_.HardwareID -like "*14C3*7925*" } | Format-List InstanceId
Write-Host "When done, run the installDriver.ps1 script." -ForegroundColor Magenta