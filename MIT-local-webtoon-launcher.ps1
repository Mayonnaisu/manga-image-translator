# Set delete options for merged images & MIT result folder content (except for log.txt) 
$DeleteMergedImages = $True
$CleanMITresultFolder = $True

# Change global preference for all error to terminate the process
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $True

# Start the launcher
try {
    Write-Host "`nLaunching..." -ForegroundColor Yellow
    
    # Read input path from MIT-input-path.txt
    try {
        $InputPath = Get-Content -Path ".\MIT-input-path.txt" | ForEach-Object { $ExecutionContext.InvokeCommand.ExpandString($_) }

        if (-not (Test-Path -Path $InputPath)) {
            Throw "$InputPath does not exist!"
        }
    } catch {
        Throw "`nERROR: $($_.Exception.Message)"
    }

    # Activate Python venv with another PowerShell script
    try {
        Write-Host "`nActivating Virtual Environment..." -ForegroundColor Yellow

        .\venv\Scripts\Activate.ps1

        Write-Host "`nVirtual Environment Activated." -ForegroundColor Green
    } catch {
        Throw "`nERROR: Failed to Activate Virtual Environment!`n$($_.Exception.Message)"
    }

    # Merge all images in each chapter folder into two respectively
    try {
        Write-Host "`nMerging All Input Images in Each Subfolder..." -ForegroundColor Yellow

        python .\my_tools\image_merger.py $InputPath 2

        if ($LASTEXITCODE -ne 0) {
            Throw "Failed to Merge Images!`nEXIT CODE: $LASTEXITCODE."
        } else {
            Write-Host "`nAll Input Images Merged and Saved to $($InputPath)_merged." -ForegroundColor Green
        }
    } catch {
        Throw "`nERROR: $($_.Exception.Message)"
    }

    # Run Manga Image Translator in local (batch) mode
    try {
        Write-Host "`nRunning Manga Image Translator in Local Mode... " -ForegroundColor Yellow

        python -m manga_translator local -v -i "$($InputPath)_merged" --config-file ".\examples\my-config.json"

        if ($LASTEXITCODE -ne 0) {
            Throw "Manga Image Translator Ran into Exception!`nEXIT CODE: $LASTEXITCODE."
        } else {
            if ($DeleteMergedImages) {
                Remove-Item -Path "$($InputPath)_merged" -Recurse -Force -Confirm:$false
            } 
            if ($CleanMITresultFolder) {
                Get-ChildItem -Path ".\result" -Recurse | Where-Object { $_.Name -notlike "log_*.txt" } | Remove-Item -Recurse -Force -Confirm:$false
            }
            Write-Host "`nAll Images Translated & Saved to $($InputPath)_merged-translated" -ForegroundColor Green
        }
    } catch {
        Throw "`nERROR: $($_.Exception.Message)"
    }

    # Split all images in each chapter folder into the number of input/original images.
    try {
        Write-Host "`nSplitting All Translated Images in Each Subfolder..." -ForegroundColor Yellow

        python .\my_tools\image_splitter.py "$($InputPath)_merged-translated"

        if ($LASTEXITCODE -ne 0) {
            Throw "Failed to Split Images!`nEXIT CODE: $LASTEXITCODE."
        } else {
            if ($DeleteMergedImages) {
                Remove-Item -Path "$($InputPath)_merged-translated" -Recurse -Force -Confirm:$false

                Remove-Item -Path "$($InputPath)_merged-translated2" -Recurse -Force -Confirm:$false
            }
            Write-Host "`nAll Translated Images Splitted and Saved to $($InputPath)-translated." -ForegroundColor Green
        }
    } catch {
        Throw "`nERROR: $($_.Exception.Message)"
    }

    Write-Host "`nLauncher Ran Successfully." -ForegroundColor Green
} catch {
    Write-Host "`n$($_.Exception.Message)`n`nLauncher Ran into Error!" -ForegroundColor Red
}

# Show exit confirmation
Write-Host "`nPress Enter to exit" -ForegroundColor Cyan -NoNewLine
Read-Host