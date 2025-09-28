## Download
1. Click on the green button on the top.
2. Select "Download ZIP".
3. Right click on the downloaded .zip file.
4. Select "Extract Here" with WinRAR or 7-Zip.

## Installation (Not Tested Yet)
1. Open PowerShell as Administrator.
2. Change PowerShell execution policy by entering command below:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
```
3. Enter y or yes.
4. Close the PowerShell.
> [!NOTE]
> The installer is for Windows 11. If you use Windows 10:
> - open `MIT-installer.ps1` with text/code editor (Notepad, VS Code, etc).
> - Change `Windows11SDK.26100` to `Windows10SDK`.
> - Save.
6. Right click on `MIT-installer.ps1`.
7. Select "Run with PowerShell".
9. Select "Yes" when UAC prompt pops up.
10. Wait until you get "<span style="color: LightGreen;">INSTALLATION COMPLETED!</span>" message.

## Configuration
### Required
1. Open `.env` file with text/code editor.
2. Paste your [Gemini API key](https://github.com/Mayonnaisu/manga-image-translator?tab=readme-ov-file#how-to-get-gemini-api-key) between the quotation marks.
3. Save.
4. Open `MIT-local-launcher.ps1` with text/code editor.
5. Replace `manga-folder` with your actual manga folder.
    > For example, if your manga folder is located in `C:\Users\mayonnaisu\Downloads\naruto`, then change `$env:USERPROFILE\Downloads\manga-folder` to `$env:USERPROFILE\Downloads\naruto`
6. Save.

### Optional
1. Go to examples folder.
2. Open `my-config.json` with text/code editor.
3. Change the settings as you see fit.
4. Save.

## Usage (CPU Mode)
### Local (Batch) Mode
1. Right click on `MIT-local-launcher.ps1`.
2. Select "Run with PowerShell".

### Web Mode
1. Right click on `MIT-web-launcher.ps1`.
2. Select "Run with PowerShell".

## How to Get Gemini API Key
1. Visit https://aistudio.google.com/app/apikey.
2. Accept Terms and Conditions.
3. Click "Create API key".
4. Name your key.
5. Choose project > Create project.
6. Select the newly created project.
7. Click "Create key".
8. Click the code in the "Key" column.
9. Click "Copy key".
