$updateUrl = "https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/MIT-update.txt"
$updatePath = "./MIT-update.txt"

try {
    # Download MIT-update.txt from my repo
    Write-Host "Downloading Update Content from $updateUrl..." -ForegroundColor Yellow
    Invoke-WebRequest -UseBasicParsing -Uri $updateUrl -OutFile $updatePath -ErrorAction Stop
    Write-Host "`nUpdate Content Downloaded to $outputPath." -ForegroundColor DarkGreen
    try {
    # Read the the commands from MIT-update.txt and execute them
    Get-Content -Path $updatePath | Invoke-Expression
    } catch {
        Write-Host "`nError during commands execution: $($_.Exception.Message)" -ForegroundColor Red
    }
} catch {
    Write-Host "`nError during download: $($_.Exception.Message)" -ForegroundColor Red
}