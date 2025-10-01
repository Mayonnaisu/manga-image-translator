$InputPath = "$env:USERPROFILE\Downloads\manga-folder"

# Activate Python venv with another PowerShell script
Write-Host "Activating Virtual Environment..." -ForegroundColor Yellow

.\venv\Scripts\Activate.ps1

Write-Host "`nVirtual Environment Activated." -ForegroundColor Green

# Merge all images in each chapter folder into one respectively
Write-Host "`nMerging All Input Images in Each Subfolder..." -ForegroundColor Yellow

python .\my_tools\image-merger_all.py $InputPath

Write-Host "`nAll Input Images Merged and Saved to $($InputPath)_combined." -ForegroundColor Green

# Run Manga Image Translator in local (batch) mode
Write-Host "`nRunning Manga Image Translator in Local Mode... " -ForegroundColor Yellow

python -m manga_translator local -v -i "$($InputPath)_combined" --config-file ".\examples\my-config.json"

# Split all images in each chapter folder into the number of input/original images.
Write-Host "`nSplitting All Translated Images in Each Subfolder..." -ForegroundColor Yellow

python .\my_tools\image-splitter.py "$($InputPath)_combined-translated" 

Write-Host "`nAll Translated Images Splitted and Saved to $($InputPath)-translated." -ForegroundColor Green

# Show delete confirmation for merged images
while ($true) {
    Write-Host "`nDo you want to delete merged input images in '$($InputPath)_combined'?" -ForegroundColor Black -BackgroundColor Yellow
    $confirmRemoval = Read-Host -Prompt "ENTER y or n"

    if ($confirmRemoval -ieq 'y') {
        Write-Host "`nDeleting Merged Images... " -ForegroundColor Yellow
        Remove-Item -Path "$($InputPath)_combined" -Recurse -Force -Confirm:$false
        Write-Host "`nMerged Input Images Deleted." -ForegroundColor Green
        break
    } ElseIf ($confirmRemoval -ieq 'n') {
        Write-Host "`nMerged Input Images Retained." -ForegroundColor Yellow
        break
    } else {
        Write-Host "`nInvalid input. Please type 'y' or 'n', then press ENTER." -ForegroundColor Red
    }
}

# Show exit confirmation
Write-Host "`nPress Enter to exit" -ForegroundColor Cyan -NoNewLine
Read-Host