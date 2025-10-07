## 📂 Directory
*   [NOTICE](#notice)
*   [ABOUT](#about)
*   [DOWNLOAD](#download)
*   [INSTALLATION](#installation)
*   [CONFIGURATION](#configuration)
    *   [Required](#required)
    *   [Optional](#optional)   
*   [USAGE (CPU MODE)](#usage-cpu-mode)
    *   [Local Mode](#local-mode)
    *   [Local Webtoon Mode](#local-webtoon-mode)
    *   [Web Mode](#web-mode)
*   [UPDATE](#update)
*   [EXTRA INFO](extra-info)
    *   [How to Get Gemini API Key](#how-to-get-gemini-api-key)
    *   [Webtoon Mode](#webtoon-mode)

## NOTICE
### <mark>Some things have been changed & fixed, so it's recommended to update to newer components if you have installed it before. See the [UPDATE section for more info](https://github.com/Mayonnaisu/manga-image-translator/tree/main/my_tools#update).</mark>

### Since the guide has become too long and complex than originally intended, I decided to simplify it. You can see the more detailed version of this guide [here](https://github.com/Mayonnaisu/manga-image-translator/tree/main/my_tools#-directory).

## ABOUT
This fork doesn't change the core functions of the original program. This is still Manga Image Translator, but with some minor tweaks & extra components to make it easier and more convenient to set up and use.
> [!NOTE]
> For more info about the main usage of MIT, always refer to https://github.com/zyddnys/manga-image-translator.

#### The Changes:
- Add installer
- Add updater
- Add launchers
- Add .env file
- Add input-path.txt
- Improve handling of webtoon format (🛠️**working but need improvement**)
- Sort input folders in natural order
- Use recommended configurations by default
- Disable some functions in order to bypass errors
- Clean up result folder except for log file by default

> [!WARNING]
> **The installer only supports Windows 10 & 11.**

## DOWNLOAD
1. Click on the green button on the top.
2. Select "Download ZIP".
3. Right click on the downloaded .zip file.
4. Select "Extract Here" with WinRAR or 7-Zip.

## INSTALLATION
1. Open PowerShell as Administrator.
2. Change PowerShell execution policy by entering the command below:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
```
3. Enter y or yes.
4. Close the PowerShell.
5. Right click on `MIT-installer.ps1`.
6. Select "Run with PowerShell".
9. Select "Yes" when UAC prompt pops up.
10. Wait until you get ${{\color{lightgreen}{\textsf{INSTALLATION COMPLETED!}}}}\$ message.
> [!NOTE]
> If you get a warning when opening the installer, uncheck the option, then Open. If you don't do this, the script won't be able to run properly.
	<details>
		<summary>View image</summary>
			<p align="center">
				<img width=350 alt="Warning for Script"
	title="Warning for Script" src="https://github.com/user-attachments/assets/47fcd43d-3b53-4751-b716-41afd6d2053a" />
			</p>
	</details>

## CONFIGURATION
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

## USAGE (CPU MODE)
> [!NOTE]
> - All local modes support batch translation.
> - The first time you run the program, it will automatically download the selected detection, OCR, & inpainting models. After that, it won't need to do it again, unless you have changed the configurations in `my-config.json`.
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

## UPDATE
> [!WARNING]
> This updater will replace the old files with the newer ones, so make sure that you back up the files you want to keep first. For more info, see [here](https://github.com/Mayonnaisu/manga-image-translator/tree/main/my_tools?tab=readme-ov-file#update).

1. Download `MIT-updater.ps1`.
2. Move it to your `manga-image-translator-main` folder.
3. Right click on it > Run with PowerShell.
4. Wait until you get ${{\color{lightgreen}{\textsf{UPDATE COMPLETED!}}}}\$ message.

## EXTRA INFO
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
> [!NOTE]
> Gemini API Free Tier has rate limits, see: https://ai.google.dev/gemini-api/docs/rate-limits#current-rate-limits.
>
> **To check your quota:**
> 1. Visit https://aistudio.google.com/app/usage
> 2. Make sure you are on the right account & project.
> 2. Click "Open in Cloud Console" on the bottom.
> 3. Scroll down > Click "Quotas & System Limits".
> 4. Scroll down > You will see your model quota usage on the top result. If you don't see it, use Filter to search it.
>
> For example: 
	<details>
		<summary>View image</summary>
			<p align="center">
				<img alt="Gemini Free Tier Quota"
	title="Gemini Free Tier Quota" src="https://github.com/user-attachments/assets/ad6d62e8-41da-4ac4-b6ab-4d893cf2f18b" />
			</p>
	</details>

### Webtoon Mode
> [!WARNING]
> This mode will attempt to merge all images in each chapter folder into two quite long images respectively first. MIT then will have to load and process the long-ass images for translation, which inevitably causes it to consume a lot more RAM and time than regular mode. Last but not least, it will merge the two translated images into one before splitting all translated images back into the same number of parts as the original images in each folder (the height and the split position won't be identical tho). For more info, see [here](https://github.com/Mayonnaisu/manga-image-translator/tree/main/my_tools#webtoon-mode).

#### Pros
- Better translation result because the translator will get all texts from half chapter at once, so it will have more contexts than when it receives the texts from only one page at a time.
- Better OCR result in a way as there is only one potentially split speech bubble resulting in incomplete text detection.

#### Cons
- Slower and heavier.
- Speech bubbles are dirtier.
- ~~Prone to server overloaded error.~~ **(just retry it XD)**<br>

> [!NOTE]
> The webtoon mode can use up to around 18GB RAM on my laptop.
>
> **My PC Specs:**
> - Model: ASUS VIVOBOOK 14X M1403QA
> - CPU: AMD Ryzen™ 5 5600H (6C/12T)
> - GPU: 512MB AMD Radeon™ Vega 7 Graphics (integrated)
> - RAM: 24GB DDR4 3200 MT/s
> - Storage: 512GB M.2 NVMe™ PCIe® 3.0 SSD
> - OS: Windows 11 Home Single Language 64-bit
>
> If your PC specs are equal or better than mine, then you should be fine, probably 😅.
