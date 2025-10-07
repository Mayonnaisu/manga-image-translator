# Change global preference for all error to terminate the process
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $True

# Start the installer
Write-Host "`nStarting Installer..." -ForegroundColor Yellow

# Clear previous errors
$Error.Clear()

$LogErrorInstallDependencyPath = ".\Temp\log_errors-install-dependency.txt"
if (Test-Path -Path $LogErrorInstallDependencyPath -PathType Leaf) {
    Remove-Item -Path $LogErrorInstallDependencyPath -Force
}

# Create separate script for installing MIT dependencies in new window later on
New-Item -Path ".\Temp" -ItemType Directory -Force

$DependencyInstallerPath = ".\Temp\dependency-installer.ps1"

$DependencyInstaller = @'
Write-Host "$PWD"

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $True
$host.PrivateData.ErrorForegroundColor = "Red"

$LogErrorInstallDependencyPath = ".\Temp\log_errors-install-dependency.txt"

# Install Python 3.10.11
try {
    Write-Host "`nInstalling Python 3.10.11" -ForegroundColor Yellow

    pyenv --version

    pyenv install 3.10.11

    pyenv global 3.10.11

    if ($LASTEXITCODE -ne 0) {
        Throw "`nFailed to Install Python 3.10.11!`nEXIT CODE: $LASTEXITCODE"
    }
} catch {
    Write-Error "`nERROR: $($_.Exception.Message)"
    exit 1
}
Write-Host "`nPython 3.10.11 Installed." -ForegroundColor DarkGreen

# Set Up Python Virtual Environment
try {
    Write-Host "`nSetting Up Python Virtual Environment..." -ForegroundColor Yellow

    python -m venv venv

    if (Test-Path -Path $LogErrorInstallDependencyPath) {
        $LogErrorInstallDependency = Get-Content -Path $LogErrorInstallDependencyPath

        if ($LogErrorInstallDependency -match "No module named") {
            Throw "Failed to Create Virtual Environment!"   
        }
    }

    .\venv\Scripts\Activate.ps1 -ErrorAction Stop 
} catch {
    Write-Error "`nERROR: $($_.Exception.Message)"
    exit 1
}
Write-Host "`nPython Virtual Environment Created & Activated." -ForegroundColor DarkGreen

# Install MIT Dependencies
$requirementsPath = ".\requirements.txt"

try {
    Write-Host "`nInstalling MIT Dependencies..." -ForegroundColor Yellow

    if (-not (Test-Path -Path $requirementsPath)) {
        Throw "Path '$requirementsPath' does not exist!"
    }

    pip install -r $requirementsPath

    if ($LASTEXITCODE -ne 0) {
        Throw "`nFailed to Install MIT Dependencies!`nEXIT CODE: $LASTEXITCODE"
    }
} catch {
    Write-Error "`nERROR: $($_.Exception.Message)"
    exit 1
}
Write-Host "`nMIT Dependencies Installed." -ForegroundColor DarkGreen

exit 0
'@

Set-Content -Path $DependencyInstallerPath -Value $DependencyInstaller

# Start the installation
try {
    # Install Microsoft C++ Build Tools
    Write-Host "`nInstalling Microsoft C++ Build Tools..." -ForegroundColor Yellow

    $MsixBundlePath = ".\Temp\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"

    if (Test-Path $MsixBundlePath) {
        Write-Host "`nWinGet Already Exists at '$MsixBundlePath'. Skipping Download."
    } else {
        Write-Host "`nWinGet Not Found at '$MsixBundlePath'. Initiating Download..."
        try {
            Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile $MsixBundlePath -ErrorAction Stop

            Write-Host "`nWinGet Downloaded Successfully to '$MsixBundlePath'."
        } catch {
            Throw "`nFailed to Download WinGet!`nERROR: $($_.Exception.Message)"
        }
    }

    $DependencyZipPath = ".\Temp\DesktopAppInstaller_Dependencies.zip"

    if (Test-Path $DependencyZipPath) {
        Write-Host "`nWinGet Dependencies Already Exists at '$DependencyZipPath'. Skipping Download."
    } else {
        Write-Host "`nWinGet Dependencies Not Found at '$DependencyZipPath'. Initiating Download..."
        try {
            Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/latest/download/DesktopAppInstaller_Dependencies.zip" -OutFile $DependencyZipPath -ErrorAction Stop

            Write-Host "`nWinGet Dependencies Downloaded Successfully to '$DependencyZipPath'."
        } catch {
            Throw "`nFailed to Download WinGet Dependencies!`nERROR: $($_.Exception.Message)"
        }
    }

    $DependencyFolderPath = ".\Temp\DesktopAppInstaller_Dependencies\x64"

    try {
        Write-Host "`nInstalling WinGet..."

        Expand-Archive -Path $DependencyZipPath -DestinationPath ".\Temp\DesktopAppInstaller_Dependencies" -Force

        $Dependencies = Get-ChildItem -Path $DependencyFolderPath -Filter "*.appx*" | Select-Object -ExpandProperty FullName

        Add-AppxPackage -Path $MsixBundlePath -DependencyPath $Dependencies -Confirm:$False

        winget upgrade --accept-source-agreements

        Write-Host "`nWinGet Installed Successfully."
    } catch {
        Throw "`nFailed to Install WinGet!`nERROR: $($_.Exception.Message)"
    }

    try {
        Write-Host "`nInstalling Microsoft Visual Studio Build Tools & Its Components..."

        $myOS = systeminfo | findstr /B /C:"OS Name"

        if ($myOS.Contains("Windows 11")) {
            winget install Microsoft.VisualStudio.2022.BuildTools --force --override "--wait --passive --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.26100" --accept-source-agreements --accept-package-agreements
        } else {
            winget install Microsoft.VisualStudio.2022.BuildTools --force --override "--wait --passive --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK" --accept-source-agreements --accept-package-agreements  
        }

        if ($LASTEXITCODE -ne 0) {
            Throw "Microsoft Visual Studio Build Tools Installer Failed!`nEXIT CODE: $LASTEXITCODE."
        } else {
            Write-Host "`nMicrosoft C++ Build Tools Installed Successfully." -ForegroundColor DarkGreen
        }
    } catch {
        Throw "`nFailed to Install Microsoft C++ Build Tools!`nERROR: $($_.Exception.Message)"
    }

    # Install Pyenv Windows
    try {
        Write-Host "`nInstalling Pyenv Windows..." -ForegroundColor Yellow

        Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "./Temp/install-pyenv-win.ps1"; &"./Temp/install-pyenv-win.ps1" -ErrorAction Stop

        Write-Host "`nPyenv Windows Installed Successfully." -ForegroundColor DarkGreen
    } catch {
        Throw "`nFailed to Install Pyenv Windows!`nERROR: $($_.Exception.Message)"
    }

    # Since it's required to reopen PowerShell after installing Pyenv Windows, I'll just launch PowerShell in a new window to install Python 3.10.11 with Pyenv, set up Python virtual environment, & install MIT dependencies.
    try {
        Write-Host "`nInstalling Python, Setting Up Python Virtual Environment, & Installing MIT Dependencies..." -ForegroundColor Yellow

        $process = Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$DependencyInstallerPath`"" -PassThru -RedirectStandardError $LogErrorInstallDependencyPath

        $process | Wait-Process

        $exitCode = $process.ExitCode

        if ($exitCode -ne 0) {
            Throw "Failed to Install Python, Create Virtual Environment, & Install MIT Dependencies.`nEXIT CODE: $exitCode."
        } else {
            Write-Host "`nPython Installed, Virtual Environment Created, & MIT Dependencies Installed Successfully." -ForegroundColor DarkGreen
        }

        Remove-Item -Path $DependencyInstallerPath -Force
    } catch {
        Throw "`nERROR: $($_.Exception.Message)"
    }

    if (Test-Path -Path $LogErrorInstallDependencyPath) {
        $LogErrorInstallDependency = Get-Content -Path $LogErrorInstallDependencyPath
        
        if ($LogErrorInstallDependency -match "Error") {
            Throw "`nError Found in '$LogErrorInstallDependencyPath'!"
        }
    } 
        
    Write-Host "`nINSTALLATION COMPLETED!" -ForegroundColor Green
} catch {
    if (Test-Path -Path $LogErrorInstallDependencyPath -PathType Leaf) {
        Get-Content $LogErrorInstallDependencyPath
    }

    Write-Host "`n$($_.Exception.Message)`n`nINSTALLATION NOT COMPLETED!" -ForegroundColor Red
    # Save the contents of the $Error variable to a text file
    $ErrorLogPath = ".\Temp\log_errors-install.txt"

    $Error | Out-File -FilePath $ErrorLogPath
}

# Show exit confirmation
Write-Host "`nPress Enter to exit" -ForegroundColor Cyan -NoNewLine
Read-Host