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
		*	[Real Time Translation](#real-time-translation)
*   [USAGE (GPU MODE)](#usage-gpu-mode)
*   [UPDATE](#update)
*   [EXTRA INFO](extra-info)
	*   [How to Get Gemini API Key](#how-to-get-gemini-api-key)
	*   [Webtoon Mode](#webtoon-mode)

## NOTICE
### <mark>I just realized that the installer is broken. Not sure since when (probably since I improved the error handling 🙃), but it worked the last time I tested it lol. My bad X'D. Let me figure out how to fix this one. The source of the error is pyenv-win requires the terminal to be closed and reopened for its installation. So, it still works as long as you run the installer 2x (you may need to remove the commands for installing Microsoft C++ Build Tools if you don't want to redownload & reinstall it). See https://github.com/Mayonnaisu/manga-image-translator/issues/2.</mark>

### Some things have been changed & fixed, so it's recommended to update to newer components if you have installed it before. See the [UPDATE section for more info](https://github.com/Mayonnaisu/manga-image-translator/tree/main/my_tools#update).

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
- Add PyTorch checker
- Add folder selection feature
- Add XPU (Intel GPU) support (**untested**)
- Improve handling of webtoon format (🛠️**working but need improvement**)
- Sort input folders in natural order
- Use recommended configurations by default
- Disable some functions in order to bypass errors
- Clean up result folder except for log file by default

> [!IMPORTANT]
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
5. Right click on **MIT-installer.ps1**.
6. Select "Run with PowerShell".
7. Select "Yes" when UAC prompt pops up.
8. Wait until you get ${{\color{lightgreen}{\textsf{INSTALLATION COMPLETED!}}}}\$ message.
> [!TIP]
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
1. Open **.env** file with text/code editor (Notepad, VS Code, etc).
2. Paste your [Gemini API key](https://github.com/Mayonnaisu/manga-image-translator?tab=readme-ov-file#how-to-get-gemini-api-key) between the quotation marks.
3. Save.

### Optional
1. Open **my-config.json** and **gpt_config-example.yaml** in **examples** folder & **settings.json** in **my_tools** folder with text/code editor.
2. Change the settings as you see fit.
3. Save.

## USAGE (CPU MODE)
> [!NOTE]
> - All local modes support batch translation.
> - The first time you run the program, it will automatically download the selected detection, OCR, & inpainting models. After that, it won't need to do it again, unless you have changed the relevant configurations in **my-config.json**.
### Local Mode
1. Right click on **MIT-local-launcher.ps1**.
2. Select "Run with PowerShell".
3. Select a folder containing your manga/hwa/hua.

### Local Webtoon Mode
> [!WARNING]
> This launcher has [a really high RAM usage!](https://github.com/Mayonnaisu/manga-image-translator?tab=readme-ov-file#webtoon-mode)
1. Right click on **MIT-local-webtoon-launcher.ps1**.
2. Select "Run with PowerShell".
3. Select a folder containing your manga/hwa/hua.

### Web Mode
1. Right click on **MIT-web-launcher.ps1**.
2. Select "Run with PowerShell".
3. Visit http://127.0.0.1:8000 (default).
4. Press Q to stop the server.

	#### Real-Time Translation
	There are a bunch of available browser extensions out there, but I will use [ComicReadScript](https://github.com/hymbz/ComicReadScript) here. In general, they have similar configurations.
	- Install Tampermonkey from https://www.tampermonkey.net
		> Next, if you use Chromium-based browser, then you need to follow the steps here: https://www.tampermonkey.net/faq.php#Q209.
	- Install ComicRead from https://sleazyfork.org/en/scripts/374903-comicread
	- Visit RAW manga/hwa/hua website.
	- Select a chapter from any available series.
	- Click on Extensions menu bar > Tampermonkey.
	- Select "Enter simple reading mode"
	- Hover your mouse over the left side of the page.
	- Click on "Scroll mode" button.
	- Hover over the left > "Settings":
		<details>
			<summary>View config</summary>
				<p align="center">
					<img width=300 alt="ComicReadScript Config"
		title="ComicReadScript Config" src="https://github.com/Mayonnaisu/manga-image-translator/blob/main/my_tools/docs/images/ComicReadScript_config.png?raw=true"/>
				</p>
		</details>
	- Click on "Settings" button to close.
	- Click on "Translate current page" or "Translate current page to the end".
> [!TIP]
> - If your PC is slow, it won't actually be real time. So, consider using GPU if you have a powerful one.
> - Check the PowerShell to see more detailed progress of the translation process.

## USAGE (GPU MODE)
Go to [here](https://github.com/Mayonnaisu/manga-image-translator/tree/main/my_tools?tab=readme-ov-file#usage-gpu-mode).

## UPDATE
> [!WARNING]
> This updater will replace the old files with the newer ones, so make sure to back up the files you want to keep first. For more info, see [here](https://github.com/Mayonnaisu/manga-image-translator/tree/main/my_tools?tab=readme-ov-file#update).

1. Download **MIT-updater.ps1**.
	> only if there is no `### VERSION ###` in your **MIT-updater.ps1**.
2. Move it to your **manga-image-translator-main** folder.
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
> [!TIP]
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
- Some texts are not detected and/or inpainted at all just like in regular mode. It's just that the missed areas will be different because the difference in their image heights. That's why it's recommended to increase or decrease `detection_size` & `inpainting_size` in **my-config.json** to improve the result. See https://github.com/zyddnys/manga-image-translator?tab=readme-ov-file#tips-to-improve-translation-quality.
- ~~Prone to server overloaded error.~~ **(just retry it XD)**<br>
It seems that it's not really caused by the launcher, or is it? 🤔, since even the paid users are experiencing the same issue, see: https://github.com/google-gemini/gemini-cli/issues/4360. Alternatively, you can change the model in **.env** file or the translator in **my-config.json**.

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
