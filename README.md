## 📂 Directory
*   [About](#about)
*   [Download](#download)
*   [Installation](#installation)
*   [Configuration](#configuration)
    *   [Required](#required)
    *   [Optional](#optional)   
*   [Usage (CPU Mode)](#usage-cpu-mode)
    *   [Local Mode](#local-mode)
    *   [Local Webtoon Mode](#local-webtoon-mode)
    *   [Web Mode](#web-mode)
*   [Update](#update)
*   [Extra Info](extra-info)
    *   [How to Get Gemini API Key](#how-to-get-gemini-api-key)
    *   [Webtoon Mode](#webtoon-mode)

## About
This fork doesn't change the core functions of the original program. This is still Manga Image Translator, but with some minor tweaks & extra components to make it easier and more convenient to set up and use.
> [!NOTE]
> For more info about the main usage of MIT, always refer to https://github.com/zyddnys/manga-image-translator.

#### The Changes:
- Add installer
- Add updater
- Add launchers
- Add .env file
- Improve handling of webtoon format (🛠️**working but need improvement**)
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
4. Open `MIT-input-path.txt` with text/code editor.
5. Replace `manga-folder` with your actual manga folder.
    > For example, if your manga folder is located in `C:\Users\mayonnaisu\Downloads\Naruto`, change `$env:USERPROFILE\Downloads\manga-folder` to `$env:USERPROFILE\Downloads\Naruto` or simply `C:\Users\mayonnaisu\Downloads\Naruto`.
6. Save.

### Optional
1. Go to examples folder.
2. Open `my-config.json` & `gpt_config-example.yaml` with text/code editor.
3. Change the settings as you see fit.
4. Save.

## Usage (CPU Mode)
> [!NOTE]
> All local modes support batch translation.
### Local Mode
1. Right click on `MIT-local-launcher.ps1`.
2. Select "Run with PowerShell".

### Local Webtoon Mode
> [!WARNING]
> This launcher has [a really high RAM usage!](https://github.com/Mayonnaisu/manga-image-translator?tab=readme-ov-file#webtoon-mode)
1. Right click on `MIT-local-webtoon-launcher.ps1`.
2. Select "Run with PowerShell".

### Web Mode
1. Right click on `MIT-web-launcher.ps1`.
2. Select "Run with PowerShell".

## Update
> [!WARNING]
> This updater will replace the old files with the newer ones, so make sure that you back up the files you want to keep first.<br>
> **Impacted files:**
> - `MIT-installer.ps1`
> - `MIT-local-launcher.ps1`
> - `MIT-local-webtoon-launcher.ps1`
> - `MIT-web-launcher.ps1`
> - `MIT-update-content.ps1`
> - `requirements.txt`
> - Files inside `my_tools` folder.
1. Download `MIT-updater.ps1` (if you haven't yet or if yours is the old version).
2. Move it to your `manga-image-translator-main` folder.
2. Right click on it > Run with PowerShell.
3. Wait until you get ${{\color{lightgreen}{\textsf{UPDATE COMPLETED!}}}}\$ message.

## Extra Info
### How to Get Gemini API Key
1. Visit https://aistudio.google.com/app/apikey.
2. Accept the Terms and Conditions.
3. Click "Create API key".
4. Name your key.
5. Choose project > Create project.
6. Select the newly created project.
7. Click "Create key".
8. Click the code in the "Key" column.
9. Click "Copy key".

### Webtoon Mode
> [!WARNING]
> This mode will attempt to merge all images in each chapter folder into one really long image respectively first. MIT then will have to load and process the long-ass images for translation, which inevitably causes it to consume a lot more RAM and time than regular mode. Not only that, it will also split all translated images into the number of original images in each folder (the height and the split position won't be identical tho). 

#### Pros
- Better translation result because the translator will get all texts from one chapter at once, so it will have more contexts than when it receives the texts from only one page at a time.
- Better OCR result in a way as there is no splitted speech bubble resulting in incomplete text detection.

#### Cons
- Slower and heavier.
- Speech bubbles are dirtier.
- Prone to server overloaded error. (just retry it XD)
- ~~Image size gets significantly bigger because images are converted to .png format to handle extremely long images since the supported maximum dimension for .jpg format is too limited.~~
- ~~Reading position may not be saved properly if your reading app uses the last page opened instead of something like the last scroll position.~~
