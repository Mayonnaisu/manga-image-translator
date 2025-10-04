# Set delete options for MIT result folder content (except for log.txt) 
$CleanMITresultFolder = $True

# Change global preference for all error to terminate the process
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $True

# Read input path from MIT-input-path.txt
try {
    $InputPath = Get-Content -Path ".\MIT-input-path.txt" | ForEach-Object { $ExecutionContext.InvokeCommand.ExpandString($_) }
    
    if (-not (Test-Path -Path $InputPath)) {
        Throw "$InputPath does not exist!"
    }
} catch {
    Write-Host "`nERROR: $($_.Exception.Message)" -ForegroundColor Red
}

# Activate Python venv with another PowerShell script
try {
    Write-Host "`nActivating Virtual Environment..." -ForegroundColor Yellow

    .\venv\Scripts\Activate.ps1

    Write-Host "`nVirtual Environment Activated." -ForegroundColor Green
} catch {
    Write-Host "`nERROR: Failed to Activate Virtual Environment!`n$($_.Exception.Message)" -ForegroundColor Red
}

# Run Manga Image Translator in local (batch) mode
try {
    Write-Host "`nRunning Manga Image Translator in Local Mode... " -ForegroundColor Yellow

    python -m manga_translator local -v -i $InputPath --config-file ".\examples\my-config.json"

    if ($LASTEXITCODE -ne 0) {
        Throw "Manga Image Translator Run into ERROR!`nEXIT CODE: $LASTEXITCODE."
    } else {
        if ($CleanMITresultFolder) {
            Get-ChildItem -Path ".\result" -Recurse | Where-Object { $_.Name -notlike "log_*.txt" } | Remove-Item -Recurse -Force -Confirm:$false
        }
        
        Write-Host "`nAll Images Translated & Saved to $($InputPath)_combined-translated" -ForegroundColor Green
    }
} catch {
    Write-Host "`nERROR: $($_.Exception.Message)" -ForegroundColor Red
}

# Show exit confirmation
Write-Host "`nPress Enter to exit" -ForegroundColor Cyan -NoNewLine
Read-Host