# Set delete options for MIT result folder content (except for log.txt) 
$CleanMITresultFolder = $True

$CleanMITresultFolderPath = Get-ChildItem -Path ".\result" -Recurse | Where-Object { $_.Name -notlike "log_*.txt" }

# Change global preference for all error to terminate the process
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $True

# Activate Python venv with another PowerShell script
try {
    Write-Host "`nActivating Virtual Environment..." -ForegroundColor Yellow

    .\venv\Scripts\Activate.ps1

    Write-Host "`nVirtual Environment Activated." -ForegroundColor Green
} catch {
    Write-Host "`nERROR: Failed to Activate Virtual Environment!`n$($_.Exception.Message)" -ForegroundColor Red
}

# Run Manga Image Translator in web mode
try {
    Write-Host "`nRunning Manga Image Translator in Web Mode... " -ForegroundColor Yellow

    python .\server\main.py

    if ($LASTEXITCODE -ne 0) {
        Throw "Manga Image Translator Run into ERROR!`nEXIT CODE: $LASTEXITCODE."
    } else {
        if ($CleanMITresultFolder) {
            Remove-Item -Path $CleanMITresultFolderPath -Recurse -Force -Confirm:$false
        }
    }
} catch {
    Write-Host "`nERROR: $($_.Exception.Message)" -ForegroundColor Red
}