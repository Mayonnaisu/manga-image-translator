$updateUrl = "https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/MIT-update-content.ps1"
$updatePath = "./MIT-update-content.ps1"

try {
    # Download MIT-update-content.ps1 from my repo
    Write-Host "Downloading Update Content from $updateUrl..." -ForegroundColor Yellow
    Invoke-WebRequest -UseBasicParsing -Uri $updateUrl -OutFile $updatePath -ErrorAction Stop
    Write-Host "`nUpdate Content Downloaded to $updateUrl." -ForegroundColor DarkGreen
    try {
    # Run MIT-update-content.ps1
    & $updatePath
    } catch {
        Write-Host "`nError during commands execution: $($_.Exception.Message)" -ForegroundColor Red
    }
} catch {
    Write-Host "`nError during download: $($_.Exception.Message)" -ForegroundColor Red
}

# Show exit confirmation
Write-Host "`nPress Enter to exit" -ForegroundColor Cyan -NoNewLine
Read-Host