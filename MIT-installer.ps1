# Install Microsoft C++ Build Tools
Write-Host "`nInstalling Microsoft C++ Build Tools..." -ForegroundColor Yellow

New-Item -Path "C:\Temp" -ItemType Directory -Force

$MsixBundlePath = "C:\Temp\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"

if (Test-Path $MsixBundlePath) {
    Write-Host "`nFile '$MsixBundlePath' already exists. Skipping download."
} else {
    Write-Host "`nFile not found. Initiating download..."
    try {
        Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile $MsixBundlePath -ErrorAction Stop
        Write-Host "`nDownload completed successfully to '$destinationPath'."
    } catch {
        Write-Host "`nError during download: $($_.Exception.Message)"
    }
}

$DependencyZipPath = "C:\Temp\DesktopAppInstaller_Dependencies.zip"

if (Test-Path $DependencyZipPath) {
    Write-Host "`nFile '$DependencyZipPath' already exists. Skipping download."
} else {
    Write-Host "`nFile not found. Initiating download..."
    try {
        Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/latest/download/DesktopAppInstaller_Dependencies.zip" -OutFile $DependencyZipPath -ErrorAction Stop
        Write-Host "`nDownload completed successfully to '$destinationPath'."
    } catch {
        Write-Host "`nError during download: $($_.Exception.Message)"
    }
}

Expand-Archive -Path $DependencyZipPath -DestinationPath "C:\Temp\DesktopAppInstaller_Dependencies" -Force

$DependencyFolderPath = "C:\Temp\DesktopAppInstaller_Dependencies\x64"

$Dependencies = Get-ChildItem -Path $DependencyFolderPath -Filter "*.appx*" | Select-Object -ExpandProperty FullName

Add-AppxPackage -Path $MsixBundlePath -DependencyPath $Dependencies -Confirm:$False

winget upgrade --accept-source-agreements

$myOS = systeminfo | findstr /B /C:"OS Name"
if ($myOS.Contains("11")) {
    winget install Microsoft.VisualStudio.2022.BuildTools --force --override "--wait --passive --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.26100" --accept-source-agreements --accept-package-agreements
} else {
    winget install Microsoft.VisualStudio.2022.BuildTools --force --override "--wait --passive --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK" --accept-source-agreements --accept-package-agreements  
}

Write-Host "`nMicrosoft C++ Build Tools Installed." -ForegroundColor DarkGreen

# Install Pyenv Windows
Write-Host "`nInstalling Pyenv Windows..." -ForegroundColor Yellow
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "$env:USERPROFILE/install-pyenv-win.ps1"; &"$env:USERPROFILE/install-pyenv-win.ps1"

Write-Host "`nPyenv Windows Installed." -ForegroundColor DarkGreen

# Since it's required to reopen PowerShell after installing Pyenv Windows, I'll just launch PowerShell in a new window to install Python 3.10.11 with Pyenv, set up Python virtual environment, & install MIT dependencies.
Write-Host "`nInstalling Python, Setting Up Python Virtual Environment, & Installing MIT Dependencies..." -ForegroundColor Yellow

$ScriptPath = "$env:Temp\commands.ps1"

$Commands = @"
Write-Host '$PWD'
Write-Host "`nInstalling Python 3.10.11." -ForegroundColor DarkGreen
pyenv --version
pyenv install 3.10.11
pyenv global 3.10.11
Write-Host "`nPython 3.10.11 Installed." -ForegroundColor DarkGreen
Write-Host "`nSetting Up Python Virtual Environment..." -ForegroundColor Yellow
python -m venv venv
.\venv\Scripts\Activate.ps1
Write-Host "`nVirtual Environment Created & Activated." -ForegroundColor DarkGreen
Write-Host "`nInstalling MIT Dependencies..." -ForegroundColor Yellow
pip install -r requirements.txt
Write-Host "`nMIT Dependencies Installed." -ForegroundColor DarkGreen
"@

Set-Content -Path $ScriptPath -Value $Commands

Start-Process powershell -ArgumentList '-Command', '& "$env:Temp\commands.ps1"; Start-Sleep -Seconds 1' -Wait

Remove-Item -Path $ScriptPath -Force

Write-Host "`nPython Installed, Virtual Environment Created, & MIT Dependencies Installed." -ForegroundColor DarkGreen

# Show completion message 
Write-Host "`nINSTALLATION COMPLETED!" -ForegroundColor Green

# Show exit confirmation
Write-Host "`nPress Enter to exit" -ForegroundColor Cyan -NoNewLine
Read-Host