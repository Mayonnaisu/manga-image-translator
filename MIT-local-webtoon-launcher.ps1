$InputPath = "$env:USERPROFILE\Downloads\manga-folder"

# Activate Python venv with another PowerShell script
Write-Host "Activating Virtual Environment..." -ForegroundColor Yellow

.\venv\Scripts\Activate.ps1

Write-Host "`nVirtual Environment Activated." -ForegroundColor Green

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
        python .\my_tools\image-merger_all.py $InputPath
    } catch {
        Write-Host "`nError during download: $($_.Exception.Message)"
    }
}

Write-Host "`nAll Images Merged and Saved to $($InputPath)_combined." -ForegroundColor Green

# Run Manga Image Translator in local (batch) mode
Write-Host "`nRunning Manga Image Translator in Local Mode... " -ForegroundColor Yellow

python -m manga_translator local -v -i "$($InputPath)_combined" --config-file ".\examples\my-config.json"

# Show delete confirmation for merged images
while ($true) {
    Write-Host "`nDo you want to delete merged images in '$($InputPath)_combined'?" -ForegroundColor Black -BackgroundColor Yellow
    $confirmRemoval = Read-Host -Prompt "ENTER y or n"

    if ($confirmRemoval -ieq 'y') {
        Write-Host "`nDeleting Merged Images... " -ForegroundColor Yellow
        Remove-Item -Path "$($InputPath)_combined" -Recurse -Force -Confirm:$false
        Write-Host "`nMerged Images Deleted." -ForegroundColor Green
        break
    } ElseIf ($confirmRemoval -ieq 'n') {
        Write-Host "`nMerged Images Retained." -ForegroundColor Yellow
        break
    } else {
        Write-Host "`nInvalid input. Please type 'y' or 'n', then press ENTER." -ForegroundColor Red
    }
}

# Show exit confirmation
Write-Host "`nPress Enter to exit" -ForegroundColor Cyan -NoNewLine
Read-Host