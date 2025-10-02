# Change warning color to red
$host.PrivateData.WarningForegroundColor = 'Red'

# Download new files from my repo
$urlListFile = ".\urls.txt"

$urlList = @"
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/MIT-installer.ps1
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/MIT-local-launcher.ps1
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/MIT-local-webtoon-launcher.ps1
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/MIT-web-launcher.ps1
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/MIT-update-content.ps1
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/requirements.txt
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/my_tools/image-merger_all.py
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/my_tools/image-splitter.py
"@

Set-Content -Path $urlListFile -Value $urlList

$urls = Get-Content $urlListFile

$currentLocation = Get-Location

foreach ($url in $urls) {
    $uri = New-Object System.Uri($url)
    $filename = $uri.Segments[-1]

    $delimiter = "refs/heads/main"
    $index = $url.IndexOf($delimiter)
    $partAfterString = $url.Substring($index + $delimiter.Length)

    $outputPath = ".$partAfterString"

    $fullTargetPath = Join-Path -Path $currentLocation.Path -ChildPath $outputPath

    $directoryPath = Split-Path -Path $fullTargetPath -Parent

    New-Item -ItemType Directory -Path $directoryPath -Force | Out-Null

    Write-Host "`nDownloading $filename from $url..." -ForegroundColor Yellow
    try {
        Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $outputPath -ErrorAction Stop
        Write-Host "Successfully Downloaded to $outputPath." -ForegroundColor DarkGreen
    } catch {
        Write-Warning "`nFailed to Download $filename. Error: $($_.Exception.Message)"
    }
}

Remove-Item -Path $urlListFile -Force

# Activate Python venv
Write-Host "`nActivating Virtual Environment..." -ForegroundColor Yellow

.\venv\Scripts\Activate.ps1

Write-Host "`nVirtual Environment Activated" -ForegroundColor DarkGreen

# Install new dependencies
Write-Host "`nInstalling New Dependencies..." -ForegroundColor Yellow

pip install -r requirements.txt

Write-Host "`nThe New Dependencies Installed." -ForegroundColor DarkGreen

# Show completion message 
Write-Host "`nUPDATE COMPLETED!" -ForegroundColor Green