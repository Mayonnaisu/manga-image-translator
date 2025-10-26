# Change global preference for all error to terminate the process
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $True

# Start logging
$LogPyTorchCheckerPath = "..\Temp\log_pytorch-checker.txt"
Start-Transcript -Path $LogPyTorchCheckerPath
New-Item -Path "..\Temp" -ItemType Directory -Force | Out-Null

try {
    # Check Python version & path
    Write-Host "`n$(python --version)"
    where.exe python

    # Activate virtual environment
    ..\venv\Scripts\Activate.ps1

    # Check PyTorch installation
    Write-Host "`nChecking PyTorch Installation..." -ForegroundColor Yellow

    # NVIDIA/AMD GPU
    if ($(python -c "import torch; print(torch.cuda.is_available())") -eq $True 2>&1) {
        Write-Host "`nPyTorch GPU" -ForegroundColor Green

        & python -c "import torch; print(f'device name [0]:', torch.cuda.get_device_name(0))" | Out-String -Stream | Write-Host

        & python -m torch.utils.collect_env | Out-String -Stream | Write-Host
        
        if ($LASTEXITCODE -ne 0) {
            Throw "$($_.Exception.Message)`nEXIT CODE: $LASTEXITCODE."
        }
    # INTEL GPU
    } elseif ($(python -c "import torch; print(torch.xpu.is_available())") -eq $True 2>&1) {
        Write-Host "`nPyTorch GPU" -ForegroundColor Green

        & python -c "import torch; [print(f'[{i}]: {torch.xpu.get_device_properties(i)}') for i in range(torch.xpu.device_count())];" | Out-String -Stream | Write-Host

        & python -m torch.utils.collect_env | Out-String -Stream | Write-Host

        if ($LASTEXITCODE -ne 0) {
            Throw "$($_.Exception.Message)`nEXIT CODE: $LASTEXITCODE."
        }
    # CPU
    } else {
        Write-Host "`nPyTorch CPU" -ForegroundColor Red

        & python -m torch.utils.collect_env | Out-String -Stream | Write-Host

        if ($LASTEXITCODE -ne 0) {
            Throw "$($_.Exception.Message)`nEXIT CODE: $LASTEXITCODE."
        }
    }

    Write-Host "`nPyTorch Checker Run Successfully.`n" -ForegroundColor Green
} catch {
    Write-Host "`nERROR: $($_.Exception.Message)`n" -ForegroundColor Red
}

# Stop logging
Stop-Transcript

# Show exit confirmation
Write-Host "`nPress Enter to exit" -ForegroundColor Cyan -NoNewLine
Read-Host