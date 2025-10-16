# Set delete option for MIT result folder content (except for log.txt)
$CleanMITresultFolder = $True

# Change global preference for all error to terminate the process
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $True

# Start the launcher
try {
    Write-Host "`nLaunching..." -ForegroundColor Yellow
    
    # Select folder with FolderBrowserDialog
    Add-Type -AssemblyName System.Windows.Forms

    $lastMangaFolderPathFile = ".\my_tools\MIT-input-path.txt" 

    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog

    $folderBrowser.Description = "Select a folder:"

    if (Test-Path $lastMangaFolderPathFile) {
        $lastPath = Get-Content -Path $lastMangaFolderPathFile -Encoding UTF8
        if (Test-Path $lastPath -PathType Container) {
            $folderBrowser.SelectedPath = $lastPath
        }
    }

    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $InputPath = $folderBrowser.SelectedPath
        Write-Host "`nSelected Folder: " -ForegroundColor Green -NoNewline
        Write-Host "$InputPath"
        $InputPath | Set-Content -Path $lastMangaFolderPathFile -Encoding UTF8
    } else {
        Throw "Folder Selection Cancelled."
    }

    # Activate Python venv with another PowerShell script
    try {
        Write-Host "`nActivating Virtual Environment..." -ForegroundColor Yellow

        .\venv\Scripts\Activate.ps1

        Write-Host "`nVirtual Environment Activated." -ForegroundColor Green
    } catch {
        Throw "`nERROR: Failed to Activate Virtual Environment!`n$($_.Exception.Message)"
    }

    # Run Manga Image Translator in local (batch) mode
    try {
        Write-Host "`nRunning Manga Image Translator in Local Mode... " -ForegroundColor Yellow

        python -m manga_translator local -v -i $InputPath --config-file ".\examples\my-config.json"

        if ($LASTEXITCODE -ne 0) {
            Throw "Manga Image Translator Ran into Exception!`nEXIT CODE: $LASTEXITCODE."
        } else {
            if ($CleanMITresultFolder) {
                Get-ChildItem -Path ".\result" -Recurse | Where-Object { $_.Name -notlike "log_*.txt" } | Remove-Item -Recurse -Force -Confirm:$false
            }

            Write-Host "`nAll Images Translated & Saved to $($InputPath)-translated" -ForegroundColor Green
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