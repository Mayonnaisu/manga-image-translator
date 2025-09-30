$sourceUrl = "https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/requirements.txt"
$filePath = ".\requirements.txt"

# Download new requirements.txt from my repo
Write-Host "Downloading New requirements.txt from $sourceUrl..." -ForegroundColor Yellow

Invoke-WebRequest -UseBasicParsing -Uri $sourceUrl -OutFile $filePath

Write-Host "`nrequirements.txt Saved to $([System.IO.Path]::GetFullPath($filePath))." -ForegroundColor DarkGreen

# Install new dependencies
Write-Host "`nInstalling the New Dependencies..." -ForegroundColor Yellow

pip install -r requirements.txt

Write-Host "`nThe New Dependencies Installed." -ForegroundColor DarkGreen

# Show completion message 
Write-Host "`nUPDATE COMPLETED!" -ForegroundColor Green

# Show exit confirmation
Write-Host "`nPress Enter to exit" -ForegroundColor Cyan -NoNewLine
Read-Host