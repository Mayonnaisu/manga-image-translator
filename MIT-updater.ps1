$sourceUrl = @(
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/MIT-installer.ps1
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/MIT-updater.ps1
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/MIT-local-launcher.ps1
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/MIT-local-webtoon-launcher.ps1
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/MIT-web-launcher.ps1
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/requirements.txt
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/my_tools/image-merger_all.py
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/my_tools/image-splitter.py
)

foreach ($Url in $sourceUrl) {
    $uri = New-Object System.Uri($url)
    $filename = $uri.Segments[-1]
    $outputPath = ".\$($filename)"
    Write-Host "Downloading $filename from $Url..." -ForegroundColor Yellow
    try {
        Invoke-WebRequest -UseBasicParsing -Uri $Url -OutFile $outputPath -ErrorAction Stop
        Write-Host "Successfully Downloaded to $([System.IO.Path]::GetFullPath($outputPath))." -ForegroundColor DarkGreen
    } catch {
        Write-Warning "Failed to Download $filename. Error: $($_.Exception.Message)"
    }
}

# Activate Python venv
Write-Host "Activating Virtual Environment..." -ForegroundColor Yellow

.\venv\Scripts\Activate.ps1

Write-Host "`nVirtual Environment Activated" -ForegroundColor DarkGreen

# Install new dependencies
Write-Host "`nInstalling New Dependencies..." -ForegroundColor Yellow

pip install -r requirements.txt

Write-Host "`nThe New Dependencies Installed." -ForegroundColor DarkGreen

# Show completion message 
Write-Host "`nUPDATE COMPLETED!" -ForegroundColor Green

# Show exit confirmation
Write-Host "`nPress Enter to exit" -ForegroundColor Cyan -NoNewLine
Read-Host