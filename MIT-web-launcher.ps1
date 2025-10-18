# Set server bind/host and port
$ServerHost = "127.0.0.1"
$Port = "8000"

# Set delete options for MIT result folder content (except for log.txt) 
$CleanMITresultFolder = $True

# Change global preference for all error to terminate the process
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $True

# Start the launcher
try {
    Write-Host "`nLaunching..." -ForegroundColor Yellow
    
    # Activate Python venv with another PowerShell script
    try {
        Write-Host "`nActivating Virtual Environment..." -ForegroundColor Yellow

        .\venv\Scripts\Activate.ps1

        Write-Host "`nVirtual Environment Activated." -ForegroundColor Green
    } catch {
        Throw "`nERROR: Failed to Activate Virtual Environment!`n$($_.Exception.Message)"
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
            Throw "Manga Image Translator Run into Exception!`nEXIT CODE: $LASTEXITCODE."
        } else {
            if ($CleanMITresultFolder) {
                Get-ChildItem -Path ".\result" -Recurse | Where-Object { $_.Name -notlike "log_*.txt" } | Remove-Item -Recurse -Force -Confirm:$false
            }
        }
    } catch {
        if ($ServerHost -eq "IP Address") {
            # handle the dynamic IP change when the server is running
            $NewBind = Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4' -and $_.IPAddress -like '192.168.1.*'} | Select-Object -ExpandProperty IPAddress
            if ($Bind -ne $NewBind) {
                python .\server\main.py --host $NewBind  --port $Port
            }
        } else {
            Throw "`nERROR: $($_.Exception.Message)"
        }
    }
    
    Write-Host "`nLauncher Ran Successfully." -ForegroundColor Green
} catch {
    Write-Host "`n$($_.Exception.Message)`n`nLauncher Ran into Error!" -ForegroundColor Red
}