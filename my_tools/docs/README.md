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
### <mark>The `MIT-input-path.txt` usage has been replaced with a folder selection feature.</mark>

### Some things have been changed and fixed, so it's recommended to update to newer components. See the [UPDATE section for more info](https://github.com/Mayonnaisu/manga-image-translator/tree/main/my_tools#update).

## ABOUT
This fork doesn't change the core functions of the original program. This is still Manga Image Translator, but with some minor tweaks & extra components to make it easier and more convenient to set up and use.
> [!NOTE]
> For more info about the main usage of MIT, always refer to https://github.com/zyddnys/manga-image-translator.

#### The Changes:
- Add installer
- Add updater
- Add launchers
- Add .env file
- Add folder selection feature
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
> [!NOTE]
> If you previously have **downloaded and installed** MIT **successfully** from https://github.com/zyddnys/manga-image-translator, you can simply download and run `MIT-updater.ps1` from inside the program root folder to get [all my scripts & some others](https://github.com/Mayonnaisu/manga-image-translator/tree/main/my_tools#:~:text=Impacted%20files%3A) (other modified files not included), assuming your Python virtual environment name is also "venv" and located in the root directory.

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
	title="Warning for Script" src="https://github.com/user-attachments/assets/db276338-8c2a-4a87-88dd-017df8cef515" />
			</p>
	</details>

## CONFIGURATION
### Required
1. Open `.env` file with text/code editor (Notepad, VS Code, etc).
2. Paste your [Gemini API key](https://github.com/Mayonnaisu/manga-image-translator/tree/main/my_tools#how-to-get-gemini-api-key) between the quotation marks.
3. Save.

### Optional
1. Go to examples folder.
2. Open `my-config.json` & `gpt_config-example.yaml` with text/code editor.
3. Change the settings as you see fit.
4. Save.

## USAGE (CPU MODE)
> [!NOTE]
> - All local modes support batch translation.
> - The first time you run the program, it will automatically download the selected detection, OCR, & inpainting models. After that, it won't need to do it again, unless you have changed the relevant configurations in `my-config.json`.
### Local Mode
1. Right click on `MIT-local-launcher.ps1`.
2. Select "Run with PowerShell".
3. Select a folder containing your manga/hwa/hua.

### Local Webtoon Mode
> [!WARNING]
> This launcher has [a really high RAM usage!](https://github.com/Mayonnaisu/manga-image-translator/tree/main/my_tools#webtoon-mode)
1. Right click on `MIT-local-webtoon-launcher.ps1`.
2. Select "Run with PowerShell".
3. Select a folder containing your manga/hwa/hua.

### Web Mode
1. Right click on `MIT-web-launcher.ps1`.
2. Select "Run with PowerShell".

## UPDATE
> [!NOTE]
> **Change Logs:**
> - Improve error handling. Some errors are not captured properly by PowerShell. I'm still grappling with it ⚔️.
> - Change the default image merging function back to merge into 1 image instead of 2 (**customizable:** in `MIT-local-webtoon-launcher.ps1`, change `$MergedImageNumber = 1`  to another number).
> - After translation, merge images into 1 before splitting into the number of parts as the input images if the specified merged image number is greater than 1.
> - Remove delete confirmation for merged images & set the option to automatically delete by default (**customizable** in `MIT-local-webtoon-launcher.ps1`).
> - Set the option to automatically clean up MIT `result` folder, excluding log files, by default (**customizable** in all launchers).
> - Add support for processing single folder to Webtoon Mode.
> - Add option to specify the number of split parts in `MIT-local-webtoon-launcher.ps1` (Change "original" in `$SplitPartsNumber = "original"` to a number without quotes).
> - <mark>Replace `MIT-input-path.txt` usage with folder selection feature. But, there will be new `MIT-input-path.txt` in `my_tools` folder to save the last selected folder path for persistence.</mark>
> - <mark>Move `MIT-update-content.ps1` into `my_tools` folder.</mark>
> - <mark>Add option to change server host/bind & port in `MIT-web-launcher.ps1`. For example, change `$ServerHost = "127.0.0.1"` to `$ServerHost = "IP Address"` to automatically get your PC internal IP address and make the program accessible from another device via  `http:/<your actual IP address>:8000` (e.g. http:/192.168.1.3:8000).</mark>

> [!WARNING]
> This updater will replace the old files with the newer ones, so make sure to back up the files you want to keep first.
>
> **Impacted files:**
> - <mark>`MIT-input-path.txt` (will be deleted if exists)</mark>
> - `MIT-installer.ps1`
> - `MIT-local-launcher.ps1`
> - `MIT-local-webtoon-launcher.ps1`
> - `MIT-web-launcher.ps1`
> - `MIT-update-content.ps1`
> - `MIT-deplist-updater` (will be deleted if exists)
> - `requirements.txt`
> - Files inside `my_tools` folder.
> - `__main__.py` in `/manga_translator`
> - `local.py` in `/manga_translator/mode`
1. Download `MIT-updater.ps1`.
	> only if there is a newer version.
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
> This mode will attempt to merge all images in each chapter folder into one really long image respectively first. MIT then will have to load and process the long-ass images for translation, which inevitably causes it to consume a lot more RAM and time than regular mode. Last but not least, it will merge the translated images into one* before splitting all translated images back into the same number of parts as the original images in each folder (the height and the split position won't be identical tho). For more info, see [here](https://github.com/Mayonnaisu/manga-image-translator/tree/main/my_tools#webtoon-mode).
>
> <sub>*if the specified merged image number is greater than 1.</sub>

#### Pros
- Better translation result because the translator will get all texts from one chapter at once, so it will have more contexts than when it receives the texts from only one page at a time.
- Better OCR result in a way as there is no potentially split speech bubble resulting in incomplete text detection.

#### Cons
- Slower and heavier.
- Speech bubbles are dirtier.
- ~~Prone to server overloaded error.~~ **(just retry it XD)**<br>
It seems that it's not really caused by the launcher, or is it? 🤔, since even the paid users are experiencing the same issue, see: https://github.com/google-gemini/gemini-cli/issues/4360. Alternatively, you can change the model in `.env` file, or the translator in `my-config.json` & .
- ~~Image size gets significantly bigger because images are converted to .png format to handle extremely long images since the supported maximum dimension for .jpg format is too limited.~~ **(fixed)**
- ~~Reading position may not be saved properly if your reading app uses the last page opened instead of something like the last scroll position.~~ **(fixed)**
- ~~Error when MIT inpainting an extremely long image. MIT inpainter (or Pytorch to be exact) can't handle too long images produced by `MIT-local-webtoon-launcher.ps1 > image_merger.py`. So far, the longest images it has successfully inpainted in my testing were around 150,000 pixels. It fails when I tested it on around 180k px images 🤣. I guess I have to limit the maximum height when merging images 😩.~~ **(fixed)**

> [!NOTE]
> The webtoon mode can use up to around 20GB RAM on my laptop.
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
