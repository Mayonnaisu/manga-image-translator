# Install Microsoft C++ Build Tools
Write-Host "Installing Microsoft C++ Build Tools..." -ForegroundColor Yellow

New-Item -Path "C:\Temp" -ItemType Directory -Force

$sourceUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
$destinationPath = "C:\Temp\WinGet.msixbundle"

if (Test-Path $destinationPath) {
    Write-Host "File '$destinationPath' already exists. Skipping download."
} else {
    Write-Host "File not found. Initiating download..."
    try {
        Invoke-WebRequest -Uri $sourceUrl -OutFile $destinationPath -ErrorAction Stop
        Write-Host "Download completed successfully to '$destinationPath'."
    } catch {
        Write-Host "Error during download: $($_.Exception.Message)"
    }
}

Add-AppxPackage "C:\Temp\WinGet.msixbundle"

winget source update

winget install Microsoft.VisualStudio.2022.BuildTools --force --override "--wait --passive --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.26100" --accept-source-agreements --accept-package-agreements # Replace 'Windows11SDK.26100' with 'Windows10SDK' for Windows 10

Write-Host "`nMicrosoft C++ Build Tools Installed." -ForegroundColor DarkGreen

# Install Pyenv Windows
Write-Host "`nInstalling Pyenv & Python 3.10.11..." -ForegroundColor Yellow
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "$env:USERPROFILE/install-pyenv-win.ps1"; &"$env:USERPROFILE/install-pyenv-win.ps1"

Write-Host "`nPyenv Windows Installed." -ForegroundColor DarkGreen

# Since it's required to reopen PowerShell after installing Pyenv Windows, I'll just launch PowerShell in a new window to install Python 3.10.11 with Pyenv, set up Python virtual environment, & install MIT dependencies.
Write-Host "`nInstalling Python, Setting Up Python Virtual Environment, & Installing MIT Dependencies..." -ForegroundColor Yellow

$ScriptPath2 = "$env:Temp\commands2.ps1"

$Commands2 = @"
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

Set-Content -Path $ScriptPath2 -Value $Commands2

Start-Process powershell -ArgumentList '-Command', '& "$env:Temp\commands2.ps1"; Start-Sleep -Seconds 3' -Wait

Remove-Item -Path $ScriptPath2 -Force

Write-Host "`nPython Installed, Virtual Environment Created, & MIT Dependencies Installed." -ForegroundColor DarkGreen

# Show completion message 
Write-Host "`nINSTALLATION COMPLETED!" -ForegroundColor Green

# Show exit confirmation
Write-Host "`nPress Enter to exit" -ForegroundColor Cyan -NoNewLine
Read-Host