# Activate Python venv with another PowerShell script
Write-Host "Activating Virtual Environment..." -ForegroundColor Yellow
.\venv\Scripts\Activate.ps1

Write-Host "`nVirtual Environment Activated." -ForegroundColor Green

# Run Manga Image Translator in web mode
Write-Host "`nRunning Manga Image Translator in Web Mode... " -ForegroundColor Yellow

python ./server/main.py