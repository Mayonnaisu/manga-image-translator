$InputPath = Get-Content -Path ".\MIT-input-path.txt" | ForEach-Object { $ExecutionContext.InvokeCommand.ExpandString($_) }

# Activate Python venv with another PowerShell script
Write-Host "Activating Virtual Environment..." -ForegroundColor Yellow

.\venv\Scripts\Activate.ps1

Write-Host "`nVirtual Environment Activated" -ForegroundColor Green

# Run Manga Image Translator in local (batch) mode
Write-Host "`nRunning Manga Image Translator in Local Mode... " -ForegroundColor Yellow

python -m manga_translator local -v -i $InputPath --config-file ".\examples\my-config.json"

# Show exit confirmation
Write-Host "`nPress Enter to exit" -ForegroundColor Cyan -NoNewLine
Read-Host