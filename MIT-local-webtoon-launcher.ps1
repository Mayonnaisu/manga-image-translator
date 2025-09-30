$InputPath = "$env:USERPROFILE\Downloads\manga-folder"

# Activate Python venv with another PowerShell script
Write-Host "Activating Virtual Environment..." -ForegroundColor Yellow

.\venv\Scripts\Activate.ps1

Write-Host "`nVirtual Environment Activated" -ForegroundColor Green

# Merge all images in each chapter folder into one respectively
Write-Host "`nMerging All Images in Each Subfolder..." -ForegroundColor Yellow

$ToolsPath = ".\my_tools\image-merger_all.py"

if (Test-Path $ToolsPath) {
    python .\my_tools\image-merger_all.py $InputPath
} else {
    Write-Host "`nFile not found. Initiating download..."
    New-Item -Path ".\my_tools" -ItemType Directory -Force
    try {
        Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/Mayonnaisu/manga-image-translator/refs/heads/main/my_tools/image-merger_all.py" -OutFile $ToolsPath -ErrorAction Stop
        Write-Host "`nDownload completed successfully to '$([System.IO.Path]::GetFullPath($ToolsPath))'."
    } catch {
        Write-Host "`nError during download: $($_.Exception.Message)"
    }
}

Write-Host "`nAll Images Merged and Saved to $($InputPath)_combined." -ForegroundColor Green

# Run Manga Image Translator in local (batch) mode
Write-Host "`nRunning Manga Image Translator in Local Mode... " -ForegroundColor Yellow

python -m manga_translator local -v -i "$($InputPath)_combined" --config-file ".\examples\my-config.json"

# Remove combined images
Write-Host "`nDeleting Merged Images... " -ForegroundColor Yellow

Remove-Item -Path "$($InputPath)_combined" -Force

Write-Host "`nMerged Images Deleted... " -ForegroundColor Green

# Show exit confirmation
Write-Host "`nPress Enter to exit" -ForegroundColor Cyan -NoNewLine
Read-Host