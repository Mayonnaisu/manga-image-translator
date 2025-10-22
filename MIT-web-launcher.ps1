# Set server bind/host and port
$ServerHost = "127.0.0.1"
$Port = "8000"

# Set delete options for MIT result folder content (except for log.txt) 
$CleanMITresultFolder = $True

# Change global preference for all error to terminate the process
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $True

# Define another script to run MIT server
$MITserverPath = ".\my_tools\MIT-server.ps1"

$MITserver = @'
param(
    [string]$ServerHost,
    [string]$Port
)

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $True

# Activate Python venv with another PowerShell script
try {
    Write-Host "`nActivating Virtual Environment..." -ForegroundColor Yellow
    
    .\venv\Scripts\Activate.ps1

    Write-Host "`nVirtual Environment Activated." -ForegroundColor Green
} catch {
    Throw "ERROR: Failed to Activate Virtual Environment!`n$($_.Exception.Message)"
    exit 1
}

# Run Manga Image Translator in web mode
try {
    Write-Host "`nRunning Manga Image Translator in Web Mode... " -ForegroundColor Yellow

    if ($ServerHost -eq "IP Address") {
        $Bind = Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4' -and $_.IPAddress -like '192.168.1.*'} | Select-Object -ExpandProperty IPAddress
    } else {
        $Bind = $ServerHost
    }

    python .\server\main.py --host $Bind --port $Port
    
    if ($LASTEXITCODE -ne 0) {
        Throw "Manga Image Translator Ran into Exception!`n$($_.Exception.Message)`nEXIT CODE: $LASTEXITCODE."
    }
} catch {
    if ('$ServerHost' -eq "IP Address") {
        # handle the dynamic IP change when the server is running
        $NewBind = Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4' -and $_.IPAddress -like '192.168.1.*'} | Select-Object -ExpandProperty IPAddress
        if ($Bind -ne $NewBind) {
            python .\server\main.py --host $NewBind  --port $Port
        }
    } else {
        Throw "ERROR: $($_.Exception.Message)"
        exit 1
    }
}

exit 0
'@

# Start the launcher
try {
    # Get & display PowerShell version
    $PowerShellVersion = (Get-Host).Version.ToString()
    Write-Host "PowerShell $PowerShellVersion"

    # Show launching & tips message
    Write-Host "`nLaunching..." -ForegroundColor Yellow
    
    Write-Host "`nPRESS Q TO EXIT PROPERLY." -ForegroundColor Green

    # Create & run MIT-server.ps1
    Set-Content -Path $MITserverPath -Value $MITserver

    $process = Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -File `"$MITserverPath`" -ServerHost `"$ServerHost`" -Port $Port" -PassThru -NoNewWindow

    while ($process.HasExited -eq $false) {
        if ($Host.UI.RawUI.KeyAvailable) {
            $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            if ($key.Character -eq 'q' -or $key.Character -eq 'Q') {
                Write-Host "`nStopping the Server..." -ForegroundColor Yellow
                taskkill /PID $process.Id /F /T
                Write-Host "`nServer Stopped." -ForegroundColor Green
                break
            }
        }
        Start-Sleep -Milliseconds 100
    }

    if ($LASTEXITCODE -ne 0) {
        Throw "Manga Image Translator Ran into Exception!`nEXIT CODE: $LASTEXITCODE."            
    } else {
        if ($CleanMITresultFolder) {
            Get-ChildItem -Path ".\result" -Recurse | Where-Object { $_.Name -notlike "log_*.txt" } | Remove-Item -Recurse -Force -Confirm:$false
        }
    }
    
    Write-Host "`nLauncher Ran Successfully." -ForegroundColor Green
} catch {
    Write-Host "`n$($_.Exception.Message)`n`nLauncher Ran into Error!" -ForegroundColor Red
} finally {
    Remove-Item -Path $MITserverPath -Force -Confirm:$false
}

# Show exit confirmation
Write-Host "`nPress Enter to exit" -ForegroundColor Cyan -NoNewLine
Read-Host