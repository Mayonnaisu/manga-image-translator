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

        python .\server\main.py

        if ($LASTEXITCODE -ne 0) {
            Throw "Manga Image Translator Run into Exception!`nEXIT CODE: $LASTEXITCODE."
        } else {
            if ($CleanMITresultFolder) {
                Get-ChildItem -Path ".\result" -Recurse | Where-Object { $_.Name -notlike "log_*.txt" } | Remove-Item -Recurse -Force -Confirm:$false
            }
        }
    } catch {
        Throw "`nERROR: $($_.Exception.Message)"
    }
    
    Write-Host "`nLauncher Ran Successfully." -ForegroundColor Green
} catch {
    Write-Host "`n$($_.Exception.Message)`n`nLauncher Ran into Error!" -ForegroundColor Red
}