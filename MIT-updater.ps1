### VERSION 1.0 ###

# Change global preference for all error to terminate the process
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $True

# Define update url & path
$repoUrl = "https://github.com/Mayonnaisu/manga-image-translator/archive/refs/heads/main.zip"
$downloadPath = ".\Temp\repo.zip"

try {
    # Display PowerShell version
    $PowerShellVersion = (Get-Host).Version.ToString()
    Write-Host "PowerShell $PowerShellVersion"

    # Download the latest .zip file from my repo
    Write-Host "`nDownloading Update from $repoUrl..." -ForegroundColor Yellow

    if (-not (Test-Path -Path ".\Temp" -PathType Container)) {
        New-Item -Path ".\Temp" -ItemType Directory -Force | Out-Null
    }

    Invoke-WebRequest -Uri $repoUrl -OutFile $downloadPath -ErrorAction Stop

    Write-Host "`nUpdate Downloaded to $downloadPath." -ForegroundColor Green

    try {
        # Extract repo.zip
        $extractPath = ".\Temp\repo"

        Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force

        $extractedContentPath = Get-ChildItem -Path $extractPath

        # Delete the excluded files from the extracted content
        $filesToExclude = @(
            ".env",
            "examples\my-config.json",
            "examples\gpt_config-example.yaml",
            "my_tools\settings.json"
        )

        foreach ($item in $filesToExclude) {
            $itemPath = Join-Path -Path $extractedContentPath.FullName -ChildPath $item

            Write-Host "`nExcluding $itemPath from Update." -ForegroundColor Green

            if (Test-Path $itemPath) {
                Remove-Item -Path $itemPath -Recurse -Force
            }
        }

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