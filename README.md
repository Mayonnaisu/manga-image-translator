## About
This fork doesn't change the core functions of the original program. This is still Manga Image Translator, but with some minor tweaks & extra components to make it easier and more convenient to set up and use.
> [!NOTE]
> For more info about the main usage of MIT, always refer to https://github.com/zyddnys/manga-image-translator.

#### The Changes:
- Add installer
- Add launchers
- Add .env file
- Add dependency list updater
- Improve handling of webtoon format
- Sort input folders in natural order
- Use recommended configurations by default
- Disable some functions in order to bypass errors

> [!WARNING]
> **The installer only supports Windows 10 & 11.**

## Download
1. Click on the green button on the top.
2. Select "Download ZIP".
3. Right click on the downloaded .zip file.
4. Select "Extract Here" with WinRAR or 7-Zip.

## Installation
1. Open PowerShell as Administrator.
2. Change PowerShell execution policy by entering the command below:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
```
3. Enter y or yes.
4. Close the PowerShell.
5. Right click on `MIT-installer.ps1`.
6. Select "Run with PowerShell".
7. Select "Yes" when UAC prompt pops up.
8. Wait until you get ${{\color{lightgreen}{\textsf{INSTALLATION COMPLETED!}}}}\$ message. 

## Configuration
### Required
1. Open `.env` file with text/code editor (Notepad, VS Code, etc).
2. Paste your [Gemini API key](https://github.com/Mayonnaisu/manga-image-translator?tab=readme-ov-file#how-to-get-gemini-api-key) between the quotation marks.
3. Save.
4. Open `MIT-local-launcher.ps1` & `MIT-local-webtoon-launcher.ps1` with text/code editor.
5. Replace `manga-folder` with your actual manga folder.
    > For example, if your manga folder is located in `C:\Users\mayonnaisu\Downloads\naruto`, then change `$env:USERPROFILE\Downloads\manga-folder` to `$env:USERPROFILE\Downloads\naruto`
6. Save.

### Optional
1. Go to examples folder.
2. Open `my-config.json` & `gpt_config-example.yaml` with text/code editor.
3. Change the settings as you see fit.
4. Save.

## Usage (CPU Mode)
### Local (Batch) Mode
1. Right click on `MIT-local-launcher.ps1`.
2. Select "Run with PowerShell".

### Local Webtoon Mode
> [!NOTE]
> If you downloaded the .zip file before 9:43 PM on 30 September 2025 (UTC+7), update the dependency list first:
1. Download `MIT-deplist-updater.ps1` & `MIT-local-webtoon-launcher.ps1`.
    > You may also need to re-download `image-merger_all.py` in `my_apps` folder if you have downloaded it before.
2. Move the scripts to  your `manga-image-translator-main` folder.
3. Right click on `MIT-deplist-updater.ps1`.
4. Select "Run with PowerShell".
5. Wait until you get ${{\color{lightgreen}{\textsf{UPDATE COMPLETED!}}}}\$ message. 
> [!WARNING]
> This launcher has [a really high RAM usage!](https://github.com/Mayonnaisu/manga-image-translator?tab=readme-ov-file#webtoon-mode)
6. Right click on `MIT-local-webtoon-launcher.ps1`.
7. Select "Run with PowerShell".

### Web Mode
1. Right click on `MIT-web-launcher.ps1`.
2. Select "Run with PowerShell".

## How to Get Gemini API Key
1. Visit https://aistudio.google.com/app/apikey.
2. Accept the Terms and Conditions.
3. Click "Create API key".
4. Name your key.
5. Choose project > Create project.
6. Select the newly created project.
7. Click "Create key".
8. Click the code in the "Key" column.
9. Click "Copy key".

## Webtoon Mode
> [!WARNING]
> This mode will attempt to merge all images in each chapter folder into one really long image respectively, so it will consume a lot more RAM and time than regular mode.

### Pros
- Better translation result because the translator will get all texts from one chapter at once, so it will have more contexts than when it receives the texts from only one page at a time.
- Better OCR result as there is no splitted speech bubbles resulting in incomplete text detection.

### Cons
- Slower and heavier.
- Speech bubbles are dirtier.
- Reading position may not be saved properly if your reading app uses the last page opened instead of something like the last scroll position.