### VERSION 1.1 ###

# Change global preference for all error to terminate the process
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $True

# Temporarily set the policy to 'Bypass' for the current process
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Suppress the default progress bar because it slows down process in stock PowerShell (5.1). See https://github.com/PowerShell/PowerShell/issues/2138.
$ProgressPreference = 'SilentlyContinue'

# Define update url & path
$repoUrl = "https://github.com/Mayonnaisu/manga-image-translator/archive/refs/heads/main.zip"
$downloadPath = ".\Temp\repo.zip"

try {
    # Import module/s
    Import-Module ".\my_tools\downloader.psm1"

    # Display PowerShell version
    $PowerShellVersion = (Get-Host).Version.ToString()
    Write-Host "PowerShell $PowerShellVersion"

    # Download the latest .zip file from my repo
    Write-Host "`nDownloading Update from $repoUrl..." -ForegroundColor Yellow

    if (-not (Test-Path -Path ".\Temp" -PathType Container)) {
        New-Item -Path ".\Temp" -ItemType Directory -Force | Out-Null
    }

    Start-ResumableBitsDownload -JobName "Mayonnaisu-MIT" -SourceUrl $repoUrl -DestinationPath $downloadPath

    Write-Host "`nUpdate Downloaded to $downloadPath." -ForegroundColor Green

    try {
        # Extract repo.zip
        Write-Host "`nExtracting Update Contents..." -ForegroundColor Yellow

        $extractPath = ".\Temp\repo"

        Expand-ArchiveWithProgress -ArchivePath $downloadPath -DestinationPath $extractPath

        Write-Host "`nUpdate Contents Extracted to $extractPath." -ForegroundColor Green

        # Delete the excluded files from the extracted content if already exist
        Write-Host "`nExcluding Files from Update..." -ForegroundColor Yellow

        $extractedContentPath = Get-ChildItem -Path $extractPath

        $filesToExclude = @(
            ".env",
            "examples\my-config.json",
            "examples\gpt_config-example.yaml",
            "my_tools\settings.json"
        )

        foreach ($item in $filesToExclude) {
            $itemPath = Join-Path -Path $extractedContentPath.FullName -ChildPath $item

            if (Test-Path $item) {
                if (Test-Path $itemPath) {
                    Write-Host "Excluding '$item'..." -ForegroundColor DarkYellow

                    Remove-Item -Path $itemPath -Recurse -Force

                    Write-Host "'$item' Excluded.`n" -ForegroundColor DarkGreen
                }
            }
        }

        Write-Host "Files Excluded from Update." -ForegroundColor Green

        # Copy the extracted content to current direcory
        $destinationPath = ".\"

        Copy-Item -Path "$($extractedContentPath.FullName)\*" -Destination $destinationPath -Recurse -Force

        Remove-Item -Path $extractPath -Recurse -Force -Confirm:$false

        # Remove obsolete files if exists
        Write-Host "`nRemoving Obsolete Files..."  -ForegroundColor Yellow

        $filePaths = @(
            ".\MIT-input-path.txt",
            ".\MIT-update-content.ps1"
            ".\MIT-deplist-updater.ps1",
            ".\my_tools\image-merger_all.py",
            ".\my_tools\image-splitter.py",
            ".\my_tools\MIT-update-content.ps1"
        )

        foreach ($filePath in $filePaths) {
            if (Test-Path -Path $filePath -PathType Leaf) {
            
                Write-Host "`n'$filePath' Exists. Deleting..."  -ForegroundColor Magenta
            
                Remove-Item -Path $filePath -Recurse -Force -Confirm:$false -ErrorAction Stop
            
                Write-Host "`n'$filePath' Deleted."  -ForegroundColor Blue
            } else {
                Write-Host "`n'$filePath' Does Not Exist. Skipping..." -ForegroundColor Blue
            }
        }

        Write-Host "`nObsolete Files Removed."  -ForegroundColor Green

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
            Write-Host "`nNew Dependencies Installed!" -ForegroundColor Green
        }

        Write-Host "`nUPDATE COMPLETED!" -ForegroundColor Green
    } catch {
        Write-Host "$($_.Exception.Message)`n`nUPDATE NOT COMPLETED!" -ForegroundColor Red
    }
} catch {
    Write-Host "`nFailed to Download Update`nERROR: $($_.Exception.Message)" -ForegroundColor Red
}

# Show exit confirmation
Write-Host "`nPress Enter to exit" -ForegroundColor Cyan -NoNewLine
Read-Host