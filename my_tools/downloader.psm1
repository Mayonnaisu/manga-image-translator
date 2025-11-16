Import-Module BitsTransfer

# Define function to delete the specified number line of output text
function Clear-HostLine {
    Param (
        [Parameter(Position=1)]
        [int32]$Count=1
    )

    $CurrentLine  = $Host.UI.RawUI.CursorPosition.Y
    $ConsoleWidth = $Host.UI.RawUI.BufferSize.Width

    $i = 1
    for ($i; $i -le $Count; $i++) {
        [Console]::SetCursorPosition(0,($CurrentLine - $i))
        [Console]::Write("{0,-$ConsoleWidth}" -f " ")
    }

[Console]::SetCursorPosition(0,($CurrentLine - $Count))
}

# Define function to show progress
function Show-Progress {
    param(
        [Parameter(Mandatory=$true)]
        [object]$JobId,
        [Parameter(Mandatory=$true)]
        [int32]$Line
    )

    $Job = Get-BitsTransfer -JobId $JobId
    $bytesTransferredMB = [math]::Round($Job.BytesTransferred / 1MB, 2)
    $bytesTotalMB = [math]::Round($Job.BytesTotal / 1MB, 2)

    if ($bytesTotalMB -eq 17592186044416) {
        $percentComplete = "?"
        $bytesTotalMB = "Unknown"
    } else {
        $percentComplete = [math]::Round(($Job.BytesTransferred / $Job.BytesTotal) * 100, 2)
    }
    Write-Host "Status: $($Job.JobState) | Progress: $($percentComplete)% ($($bytesTransferredMB)/$($bytesTotalMB) MB)"
    Start-Sleep -Seconds 1
    Clear-HostLine $Line
}

# Define function to download file with BitsTransfer
function Start-ResumableBitsDownload {
    param(
        [Parameter(Mandatory=$true)]
        [string]$JobName,
        [Parameter(Mandatory=$true)]
        [string]$SourceUrl,
        [Parameter(Mandatory=$true)]
        [string]$DestinationPath
    )

    Write-Host "`nStarting BITS transfer job..."

    # Check if a partial file or existing job is present and attempt to resume
    $job = Get-BitsTransfer -Name "$JobName-*" | Select-Object -First 1

    if ($job) {
        New-Variable -Name MyJobId -Value $job.JobId -Scope Global -Force
        if ($job.JobState -eq 'Transferring' -or $job.JobState -eq 'Connecting' -or $job.JobState -eq 'Transferred' -or $job.JobState -match 'Error') {
            Write-Host "Continuing..."
        } elseif ($job.JobState -eq 'Suspended') {
            Write-Host "Resuming existing BITS job: $($job.DisplayName).`n(FYI, no any indicator when resuming)"
            Resume-BitsTransfer -BitsJob $job
            if (-not ($LASTEXITCODE -ne 0)) {
                Write-Host "BITS job resumed successfully.`n"
            } else {
                Write-Host "Failed to resume BITS job.`n"
            }
        }
    } else {
        # Create a new BITS transfer job in Asynchronous mode for automatic resuming
        $jobName = "$JobName-" + (Get-Random)
        $job = Start-BitsTransfer -Source $SourceUrl -Destination $DestinationPath -Asynchronous -DisplayName $jobName -Dynamic
        New-Variable -Name MyJobId -Value $job.JobId -Scope Global -Force
        Write-Host "Created new BITS job: $($job.DisplayName)"
    }

    # Monitor the job status
    while ($job.JobState -eq 'Transferring' -or $job.JobState -eq 'Connecting') {
        Show-Progress -JobId $MyJobId -Line 1
    }

    # Handle completion or errors
    if ($job.JobState -match 'TransientError') {
        $maxRetries = 10
        $retryCount = 0
        while ($job.JobState -match 'TransientError' -and $retryCount -lt $maxRetries) {
            Write-Host "Retrying... ($($retryCount+1)/${maxRetries})"
            Show-Progress -JobId $MyJobId -Line 2
            $retryCount++
        }
        if (($job.JobState -eq 'TransientError') -and ($retryCount -eq $maxRetries)) {
            Suspend-BitsTransfer -BitsJob $job 
            Throw "Transfer suspended after max retries reached."
        }
    }

    # Monitor the job status
    while ($job.JobState -eq 'Transferring' -or $job.JobState -eq 'Connecting') {
        Show-Progress -JobId $MyJobId -Line 1
    }

    if ($job.JobState -match 'Error') {
        Suspend-BitsTransfer -BitsJob $job | Out-Null
        Throw "Transfer suspended due to error.`n$($job.ErrorDescription)"
    }

    if ($job.JobState -eq 'Transferred') {
        Complete-BitsTransfer -BitsJob $job
        Write-Host "Download complete"
    } else {
        Write-Host "Job finished with state: $($job.JobState)"
    }
}

# Define function to extract archive file
function Expand-ArchiveWithProgress {
    param (
        [string]$ArchivePath,
        [string]$DestinationPath
    )

    Add-Type -AssemblyName System.IO.Compression.FileSystem

    $zipFile = [System.IO.Compression.ZipFile]::OpenRead($ArchivePath)
    $totalEntries = $zipFile.Entries.Count
    $i = 0

    foreach ($entry in $zipFile.Entries) {
        $i++
        $percentComplete = [int](($i / $totalEntries) * 100)
        $status = "Extracting: $($entry.FullName)"

        Write-Host "($($percentComplete)%) $status"

        # Ensure the directory structure exists before extracting
        $destinationFilePath = Join-Path $DestinationPath $entry.FullName
        $destinationDirectory = Split-Path $destinationFilePath
        if (-not (Test-Path $destinationDirectory)) {
            New-Item -Path $destinationDirectory -ItemType Directory | Out-Null
        }

        # Extract the entry, skipping directories as New-Item handles them
        if (-not $entry.FullName.EndsWith('/')) {
            [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $destinationFilePath, $true)
        }
    }

    $zipFile.Dispose()
}

Export-ModuleMember -Function Start-ResumableBitsDownload, Expand-ArchiveWithProgress