# Change global preference for all error to terminate the process
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $True

$updateUrl = "https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/my_tools/MIT-update-content.ps1"
$updatePath = ".\my_tools\MIT-update-content.ps1"

try {
    # Download the latest MIT-update-content.ps1 from my repo
    Write-Host "Downloading Update Content from $updateUrl..." -ForegroundColor Yellow

    Invoke-WebRequest -UseBasicParsing -Uri $updateUrl -OutFile $updatePath -ErrorAction Stop

    Write-Host "`nUpdate Content Downloaded to $updateUrl." -ForegroundColor DarkGreen
    try {
        # Run the MIT-update-content.ps1
        & $updatePath -ErrorAction Stop

        Write-Host "`nUPDATE COMPLETED!." -ForegroundColor Green
    } catch {
        Write-Host "$($_.Exception.Message)`n`nUPDATE NOT COMPLETED!" -ForegroundColor Red
    }
} catch {
    Write-Host "`nFailed to Downlaod Update Content`nERROR: $($_.Exception.Message)" -ForegroundColor Red
}

# Show exit confirmation
Write-Host "`nPress Enter to exit" -ForegroundColor Cyan -NoNewLine
Read-Host