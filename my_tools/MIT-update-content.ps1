# Change global preference for all error to terminate the process
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $True

# Download new files from my repo
$urlList = @'
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/manga_translator/__main__.py
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/manga_translator/mode/local.py
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/manga_translator/translators/gemini.py
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/MIT-installer.ps1
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/MIT-local-launcher.ps1
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/MIT-local-webtoon-launcher.ps1
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/MIT-web-launcher.ps1
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/requirements.txt
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/my_tools/image_merger.py
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/my_tools/image_splitter.py
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/my_tools/pytorch-checker.ps1
https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/my_tools/docs/README.md
'@

$currentLocation = Get-Location

foreach ($url in $urlList -split "`n") {
    $fileName = ([uri]$url).Segments[-1]

    $delimiter = "refs/heads/main"
    $index = $url.IndexOf($delimiter)
    $partAfterString = $url.Substring($index + $delimiter.Length)

    $outputPath = ".$partAfterString"

    $fullTargetPath = Join-Path -Path $currentLocation.Path -ChildPath $outputPath

    $directoryPath = Split-Path -Path $fullTargetPath -Parent

    New-Item -ItemType Directory -Path $directoryPath -Force | Out-Null

    try {
        Write-Host "`nDownloading $fileName from $url..." -ForegroundColor Yellow

        Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $outputPath -ErrorAction Stop

        Write-Host "Successfully Downloaded to $outputPath." -ForegroundColor DarkGreen
    } catch {
        Throw "Failed to Download $fileName!`nERROR: $($_.Exception.Message)"
    }
}

# Remove obsolete files if exists
$filePaths = @(
    ".\MIT-input-path.txt",
    ".\MIT-update-content.ps1"
    ".\MIT-deplist-updater.ps1",
    ".\my_tools\image-merger_all.py",
    ".\my_tools\image-splitter.py"
)

foreach ($filePath in $filePaths) {
    if (Test-Path -Path $filePath -PathType Leaf) {

        Write-Host "`n'$filePath' Exists. Deleting..."  -ForegroundColor Yellow

        Remove-Item -Path $filePath -Recurse -Force -Confirm:$false -ErrorAction Stop

        Write-Host "`n'$filePath' Deleted."  -ForegroundColor DarkGreen
    } else {
        Write-Host "`n'$filePath' Does Not Exist. Skipping..." -ForegroundColor Blue
    }
}

# Activate Python venv
try {
    Write-Host "`nActivating Virtual Environment..." -ForegroundColor Yellow

    .\venv\Scripts\Activate.ps1

    Write-Host "`nVirtual Environment Activated." -ForegroundColor Green
} catch {
    Throw "`nFailed to Activate Virtual Environment!`nERROR: $($_.Exception.Message)"
}

# Install new dependencies
$requirementsPath = ".\requirements.txt"

Write-Host "`nInstalling New Dependencies..." -ForegroundColor Yellow

if (-not (Test-Path -Path $requirementsPath)) {
    Throw "Path '$requirementsPath' does not exist!"
}

pip install -r $requirementsPath

if ($LASTEXITCODE -ne 0) {
    Throw "`nFailed to Install New Dependencies!`nEXIT CODE: $LASTEXITCODE"
} else {
    Write-Host "`nNew Dependencies Installed!" -ForegroundColor DarkGreen
}