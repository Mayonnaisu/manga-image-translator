# Change global preference for all errors to terminate the process
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $True

# Temporarily set the policy to 'Bypass' for the current process
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Suppress the default progress bar because it slows down process in stock PowerShell (5.1). See https://github.com/PowerShell/PowerShell/issues/2138.
$ProgressPreference = 'SilentlyContinue'

# Define separate script for installing MIT dependencies in a new window later
$DependencyInstallerPath = ".\Temp\dependency-installer.ps1"

$DependencyInstaller = @'
$PowerShellVersion = (Get-Host).Version.ToString()
Write-Host "PowerShell $PowerShellVersion"

Write-Host "$PWD"

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $True
$host.PrivateData.ErrorForegroundColor = "Red"

$LogErrorInstallDependencyPath = ".\Temp\log_errors-install-dependency.txt"
Start-Transcript -Path $LogErrorInstallDependencyPath -Append

Write-Host "`nSYSTEM PATH: $([Environment]::GetEnvironmentVariable("Path", "Machine"))"

# Install Python 3.10.11
try {
    Write-Host "`nInstalling Python 3.10.11" -ForegroundColor Yellow

    pyenv --version

    pyenv install 3.10.11

    pyenv global 3.10.11

    if ($LASTEXITCODE -ne 0) {
        Throw "`nFailed to Install Python 3.10.11!`nEXIT CODE: $LASTEXITCODE"
    }
    
    pyenv versions

    python --version

    if ($? -eq $true) {
        where.exe python
    }
} catch {
    Write-Host "`nERROR: $($_.Exception.Message)"
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
    Write-Host "`nERROR: $($_.Exception.Message)"
    exit 2
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
    Write-Host "`nERROR: $($_.Exception.Message)"
    exit 3
}
Write-Host "`nMIT Dependencies Installed." -ForegroundColor DarkGreen

Stop-Transcript

exit 0
'@

# Start the installation
try {
    # Clear previous errors
    $Error.Clear()

    $LogErrorInstallDependencyPath = ".\Temp\log_errors-install-dependency.txt"
    if (Test-Path -Path $LogErrorInstallDependencyPath -PathType Leaf) {
        Remove-Item -Path $LogErrorInstallDependencyPath -Force
    }

    # Import module/s
    Import-Module ".\my_tools\downloader.psm1"

    # Display PowerShell version & start message
    $PowerShellVersion = (Get-Host).Version.ToString()
    Write-Host "PowerShell $PowerShellVersion"

    Write-Host "`nStarting Installer..." -ForegroundColor Yellow

    # Create folder and dependency-installer.ps1
    New-Item -Path ".\Temp" -ItemType Directory -Force

    Set-Content -Path $DependencyInstallerPath -Value $DependencyInstaller

    # Install Microsoft C++ Build Tools
    Write-Host "`nInstalling Microsoft C++ Build Tools..." -ForegroundColor Yellow

    $MsixBundleUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    $MsixBundlePath = ".\Temp\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"

    if (Test-Path $MsixBundlePath) {
        Write-Host "`nWinGet Already Exists at '$MsixBundlePath'. Skipping Download."
    } else {
        Write-Host "`nWinGet Not Found at '$MsixBundlePath'.`n`nDownloading from '$MsixBundleUrl'..."
        try {
            Start-ResumableBitsDownload -JobName "WinGet" -SourceUrl $MsixBundleUrl -DestinationPath $MsixBundlePath

            Write-Host "`nWinGet Downloaded Successfully to '$MsixBundlePath'."
        } catch {
            Throw "`nFailed to Download WinGet!`nERROR: $($_.Exception.Message)"
        }
    }

    $DependencyZipUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/DesktopAppInstaller_Dependencies.zip"
    $DependencyZipPath = ".\Temp\DesktopAppInstaller_Dependencies.zip"

    if (Test-Path $DependencyZipPath) {
        Write-Host "`nWinGet Dependencies Already Exists at '$DependencyZipPath'. Skipping Download."
    } else {
        Write-Host "`nWinGet Dependencies Not Found at '$DependencyZipPath'.`n`nDownloading from '$DependencyZipUrl'..."
        try {
            Start-ResumableBitsDownload -JobName "WinGet-Depedencies" -SourceUrl $DependencyZipUrl -DestinationPath $DependencyZipPath

            Write-Host "`nWinGet Dependencies Downloaded Successfully to '$DependencyZipPath'."
        } catch {
            Throw "`nFailed to Download WinGet Dependencies!`nERROR: $($_.Exception.Message)"
        }
    }

    $DependencyFolder = ".\Temp\DesktopAppInstaller_Dependencies"

    try {
        Write-Host "`nInstalling WinGet..."

        $OSArchitecture = (Get-CimInstance -ClassName Win32_OperatingSystem).OSArchitecture

        if ($OSArchitecture -eq "ARM64") {
            $DependencyPath = "$DependencyFolder\arm64"
        } elseif ($OSArchitecture -eq "64-bit") {
            $DependencyPath = "$DependencyFolder\x64"
        } elseif ($OSArchitecture -eq "32-bit") {
            $DependencyPath = "$DependencyFolder\x86"
        } else {
            $DependencyPath = "$DependencyFolder\x64"
        }

        Expand-ArchiveWithProgress -ArchivePath $DependencyZipPath -DestinationPath $DependencyFolder

        $Dependencies = Get-ChildItem -Path $DependencyPath -Filter "*.appx*" | Select-Object -ExpandProperty FullName

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

        $pathToadd = "$env:USERPROFILE\.pyenv\pyenv-win\bin;$env:USERPROFILE\.pyenv\pyenv-win\shims"

        $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')

        [Environment]::SetEnvironmentVariable('Path', "$pathToadd;$userPath", 'User')

        $id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        $p = New-Object System.Security.Principal.WindowsPrincipal($id)
        $isAdmin = $p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)

        if ($isAdmin) {
            $systemPath = [Environment]::GetEnvironmentVariable('Path', 'Machine')

            [Environment]::SetEnvironmentVariable('Path', "$pathToadd;$systemPath", 'Machine')
        }

        Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "./Temp/install-pyenv-win.ps1"; &"./Temp/install-pyenv-win.ps1" -ErrorAction Stop

        Write-Host "`nPyenv Windows Installed Successfully." -ForegroundColor DarkGreen

    } catch {
        Throw "`nFailed to Install Pyenv Windows!`nERROR: $($_.Exception.Message)"
    }

    # Since it's required to reopen PowerShell after installing Pyenv Windows, I'll just launch PowerShell in a new window to install Python 3.10.11 with Pyenv, set up Python virtual environment, & install MIT dependencies.
    try {
        Write-Host "`nInstalling Python, Setting Up Python Virtual Environment, & Installing MIT Dependencies..." -ForegroundColor Yellow

        $taskName = "Install-MIT-Dependencies"
        $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddSeconds(30)
        $taskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

        $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -Command cd $PWD; &'$DependencyInstallerPath' | Out-String -Stream | Write-Host"

        Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -Settings $taskSettings -Description "Temporary task to install MIT dependencies." -Force

        $scheduledTask = Get-ScheduledTask -TaskName $taskName -ErrorAction Stop

        Start-ScheduledTask -TaskName $taskName

        while ($scheduledTask.State -ne 'Running') {
            Start-Sleep -Seconds 5
            Write-Host "`nSTATUS: $($scheduledTask.State) | Starting scheduled task..."
            $scheduledTask = Get-ScheduledTask -TaskName $taskName
        }

        Write-Host "Scheduled task '$taskName' started. Waiting for completion..."

        while ($scheduledTask.State -eq 'Running') {
            Start-Sleep -Seconds 5
            $scheduledTask = Get-ScheduledTask -TaskName $taskName
        }

        if ($scheduledTask.State -ne 'Running') {
            Write-Host "Scheduled task '$taskName' completed. Final state: $($scheduledTask.State)"
            Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
        } else {
            Write-Host "Scheduled task '$taskName' started. Waiting for completion..."
            while (($scheduledTask.State -eq 'Running')) {
                Start-Sleep -Seconds 5
                $scheduledTask = Get-ScheduledTask -TaskName $taskName
            }
            Write-Host "Scheduled task '$taskName' completed. Final state: $($scheduledTask.State)"
            Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
        }

        if (Test-Path -Path $LogErrorInstallDependencyPath) {
            $LogErrorInstallDependency = Get-Content -Path $LogErrorInstallDependencyPath
            $ErrorMatch = $LogErrorInstallDependency -notmatch "log_error"
            if ($ErrorMatch -match "Error") {
                Throw "Failed to Install Python, Create Virtual Environment, & Install MIT Dependencies."
            } else {
                Write-Host "`nPython Installed, Virtual Environment Created, & MIT Dependencies Installed Successfully." -ForegroundColor DarkGreen
            }
            $LogErrorInstallDependency
        }

        Remove-Item -Path $DependencyInstallerPath -Force
    } catch {
        Throw "`nERROR: $($_.Exception.Message)"
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