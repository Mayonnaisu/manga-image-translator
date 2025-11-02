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
    *   [NVIDIA](#nvidia)
    *   [AMD](#amd)
    *   [INTEL](#intel)
*   [UPDATE](#update)
*   [EXTRA INFO](extra-info)
    *   [How to Get Gemini API Key](#how-to-get-gemini-api-key)
    *   [Webtoon Mode](#webtoon-mode)

## NOTICE
### <mark>The use of `settings.json` has been integrated to make the launcher-related settings more convenient and persistent. However, you need to download [`settings.json`](https://github.com/Mayonnaisu/manga-image-translator/blob/main/my_tools/settings.json) and move it to `my_tools` folder manually because it's excluded from the update.</mark>

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
- Add PyTorch checker
- Add folder selection feature
- Add XPU (Intel GPU) support. (**untested**)
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
5. Right click on `MIT-installer.ps1`.
6. Select "Run with PowerShell".
9. Select "Yes" when UAC prompt pops up.
10. Wait until you get ${{\color{lightgreen}{\textsf{INSTALLATION COMPLETED!}}}}\$ message.
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
> [!NOTE]
> GPU Mode may still not give you the speed increase you want. It's especially true if your setups and/or configurations are not optimal or if the program and/or its dependencies themselves are unoptimized or unstable.

### NVIDIA
1. Install the correct PyTorch version from https://pytorch.org/get-started/locally/ or https://pytorch.org/get-started/previous-versions/.
	> **For example, for CUDA 13.0:**
	> 1. Right click on the empty area in MIT root folder.
	> 2. Select "Open in Terminal".
	> 3. Enter the commands below:
	> ```powershell
	> .\venv\Scripts\Activate.ps1
	> python -m pip install --upgrade --force-reinstall torch torchvision --index-url https://download.pytorch.org/whl/cu130
	> ```
2. Verify PyTorch version.
	- Go to `my_tools` folder.
	- Run `pytorch-checker.ps1`.
	- Make sure it shows ${{\color{lightgreen}{\textsf{PyTorch GPU}}}}\$.
3. Modify `settings.json` in `my_tools` folder.
	- Change `gpu_mode` value from `false` to `true`.
	- Change `gpu_model` value from `"?"` to one of the models in `supported_gpu_models`.

### AMD
1. Install the correct driver (if available for your GPU model) & PyTorch versions from  https://www.amd.com/en/resources/support-articles/release-notes/RN-AMDGPU-WINDOWS-PYTORCH-PREVIEW.html or https://github.com/ROCm/TheRock/blob/main/RELEASES.md. Currently, the Windows support is still new and limited. So, PyTorch may be unstable as it's still in the preview version.
	> **For example, for [gfx110X-all](https://github.com/ROCm/TheRock/blob/main/RELEASES.md#index-page-listing) with Python 3.12 (as of now no Python 3.10 support):**
	> 1. Delete venv folder.
	> 2. Delete torch & torchvision from requirements.txt.
	> 3. Right click on the empty area in MIT root folder.
	> 4. Select "Open in Terminal".
	> 5. Enter the commands below:
	> ```powershell
	> pyenv install 3.12.0
	> pyenv global 3.12.0
	> python -m venv venv
	> .\venv\Scripts\Activate.ps1
	> pip -r requirements.txt
	> python -m pip install --upgrade --force-reinstall --index-url https://rocm.nightlies.amd.com/v2/gfx110X-all/ "rocm[libraries,devel]" --pre torch torchvision
	> ```
	> If the torch & torchvision installation failed or you get `RuntimeError: operator torchvision::nms does not exist` during translation, try manually downloading the compatible .whl file from the index URL & move it to MIT folder. For example, for rocm==7.10.0a20251024, download & move `torchvision-0.25.0a0+rocm7.10.0a20251024-cp312-cp312-win_amd64.whl`. Then, enter:
	> ```powershell
	> # Reinstall failed torchvision from wheel file
	> # This will also install incorrect torch version
	> python -m pip install --upgrade --force-reinstall ".\torchvision-0.25.0a0+rocm7.10.0a20251024-cp312-cp312-win_amd64.whl"
	>
	> # Reinstall the correct torch version from cache
	> python -m pip install --index-url https://rocm.nightlies.amd.com/v2/gfx110X-all/ --pre torch==2.10.0a0+rocm7.10.0a20251024
	> ```
	> Make sure the installed packages are compatible based on the rocm version.
	> ```powershell
	> # Check the installed packages
	> # This should return:
	> # rocm==7.10.0a20251024
	> # rocm-sdk-core==7.10.0a20251024
	> # rocm-sdk-devel==7.10.0a20251024
	> # rocm-sdk-libraries-gfx110X-all==7.10.0a20251024
	> # torch==2.10.0a0+rocm7.10.0a20251024
	> # torchvision==0.25.0a0+rocm7.10.0a20251024 OR torchvision @ file:///C:/Users/mayonnaisu/Downloads/manga-image-translator-main/torchvision-0.25.0a0%2Brocm7.10.0a20251024-cp312-cp312-win_amd64.whl#sha256=05d080af0bd09ba2af182ea62fd1dcb8b6c3ea3e00d6345d5f3aee619d755cd1
	> pip freeze | Select-String -Pattern "rocm"
	> 
	> # Clear cache if everything is good
	> pip cache purge
	> ```
2. Verify PyTorch version.
	- Go to `my_tools` folder.
	- Run `pytorch-checker.ps1`.
	- Make sure it shows ${{\color{lightgreen}{\textsf{PyTorch GPU}}}}\$.
3. Modify `settings.json` in `my_tools` folder.
	- Change `gpu_mode` value from `false` to `true`.
	- Change `gpu_model` value from `"?"` to one of the models in `supported_gpu_models`.

### INTEL
1. Install the correct driver (if available for your GPU model) & PyTorch versions from https://docs.pytorch.org/docs/stable/notes/get_start_xpu.html or https://pytorch-extension.intel.com/installation?platform=gpu.
	> **For example, for Intel Arc A-Series Graphics:**
	> 1. Install the driver for Intel Client GPUs.
	> 2. Right click on the empty area in MIT root folder.
	> 3. Select "Open in Terminal".
	> 4. Enter the commands below:
	> ```powershell
	> .\venv\Scripts\Activate.ps1
	> python -m pip install --upgrade --force-reinstall torch torchvision --index-url https://download.pytorch.org/whl/xpu
	> ```
2. Verify PyTorch version.
	- Go to `my_tools` folder.
	- Run `pytorch-checker.ps1`.
	- Make sure it shows ${{\color{lightgreen}{\textsf{PyTorch GPU}}}}\$.
3. Modify `settings.json` in `my_tools` folder.
	- Change `gpu_mode` value from `false` to `true`.
	- Change `gpu_model` value from `"?"` to one of the models in `supported_gpu_models`.

## UPDATE
> [!IMPORTANT]
> **Change Logs:**
> - Improve error handling. Some errors are not captured properly by PowerShell. I'm still grappling with it ⚔️.
> - Change the default image merging function for `MIT-local-webtoon-launcher.ps1` back to merge into 1 image instead of 2 (**customizable:** in `settings.json`, change `"merged_image_number": 1`  to another number).
> - After translation, images are merged into 1 before being splitted into the number of parts as the input images if the specified merged image number is greater than 1.
> - Remove delete confirmation for merged images & set the option to automatically delete by default (**customizable** in `settings.json`).
> - Set the option to automatically clean up MIT `result` folder, excluding log files, by default (**customizable** globally or individually in `settings.json`).
> - Add support for processing single folder to Webtoon Mode.
> - Add option to specify the number of split parts for `MIT-local-webtoon-launcher.ps1` in `settings.json` (Change "original" in `"split_part_number": "original"` to a number without quotes).
> - Replace `MIT-input-path.txt` usage with folder selection feature. But, there will be new `MIT-input-path.txt` in `my_tools` folder to save the last selected folder path for persistence.
> - Add option to change server host/bind & port for `MIT-web-launcher.ps1` in `settings.json`. For example, change `"server_host": "127.0.0.1"` to `"server_host": "IP Address"` to automatically get your PC internal IP address and make the program accessible from another device on the same network via `http://<your actual IP address>:8000` (e.g. http://192.168.1.3:8000). **It's really important to note that using "IP Address" also allows others to access your program because the MIT server doesn't have a form of authentication. So, make sure you're at least on a trusted and secure network.**
> - Use Q keypress to properly stop `MIT-web-launcher.ps1`, preventing the terminal from getting closed before cleaning up `result` folder.
> - <mark>Add XPU (Intel GPU) support. Currently, it's still untested and its integration may break some other things, like [AttributeError: module 'torch.backends' has no attribute 'xpu'](https://github.com/Mayonnaisu/manga-image-translator/commit/b6a82830357f06fb93519f32a2602db4c4f92f1b). If you encounter any error, feel free to create an [issue about it](https://github.com/Mayonnaisu/manga-image-translator/issues). I will try my best to fix it.</mark>
> - <mark>Improve `MIT-updater.ps1` and remove `MIT-update-content.ps1`. As the number of modified files increases, I decided to just download all files from the repo as .zip file. Unfortunately, in some locations, downloading from GitHub can be extremely slow, so it's recommened to use VPN/proxy when updating.</mark>
> - <mark>Integrate the use of `settings.json` to make the launcher-related settings convenient to change and unaltered by the update. This also eliminates the need to modify MIT commands and codes in every launcher when using GPU Mode. However, since it's excluded from the update, you need to manually download [`settings.json`](https://github.com/Mayonnaisu/manga-image-translator/blob/main/my_tools/settings.json) and move it to `my_tools` folder.</mark>

> [!WARNING]
> This updater will replace the old files with the newer ones, so make sure to back up the files you want to keep first.
>
> **Impacted files:**
>
> All files from repo (main), except:
> - `.\.env`
> - `.\examples\my-config.json`
> - `.\examples\gpt_config-example.yaml`
> - `.\my_tools\settings.json`
1. Download `MIT-updater.ps1`.
	> only if there is no `### VERSION ###` in your `MIT-updater.ps1`.
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
> This mode will attempt to merge all images in each chapter folder into one really long image respectively first. MIT then will have to load and process the long-ass images for translation, which inevitably causes it to consume a lot more RAM and time than regular mode. Last but not least, it will merge the translated images into one* before splitting all translated images back into the same number of parts as the original images in each folder (the height and the split position won't be identical tho).
>
> <sub>*if the specified merged image number is greater than 1.</sub>

#### Pros
- Better translation result because the translator will get all texts from one chapter at once, so it will have more contexts than when it receives the texts from only one page at a time.
- Better OCR result in a way as there is no potentially split speech bubble resulting in incomplete text detection.

#### Cons
- Slower and heavier.
- Speech bubbles are dirtier.
- Some texts are not detected and/or inpainted at all just like in regular mode. It's just that the missed areas will be different because the difference in their image heights. That's why it's recommended to increase or decrease `detection_size` & `inpainting_size` in `my-config.json` to improve the result. See https://github.com/zyddnys/manga-image-translator?tab=readme-ov-file#tips-to-improve-translation-quality.
- ~~Prone to server overloaded error.~~ **(just retry it XD)**<br>
It seems that it's not really caused by the launcher, or is it? 🤔, since even the paid users are experiencing the same issue, see: https://github.com/google-gemini/gemini-cli/issues/4360. Alternatively, you can change the model in `.env` file, or the translator in `my-config.json`.
- ~~Image size gets significantly bigger because images are converted to .png format to handle extremely long images since the supported maximum dimension for .jpg format is too limited.~~ **(fixed)**
- ~~Reading position may not be saved properly if your reading app uses the last page opened instead of something like the last scroll position.~~ **(fixed)**
- ~~Error when MIT inpainting an extremely long image. MIT inpainter (or PyTorch to be exact) can't handle too long images produced by `MIT-local-webtoon-launcher.ps1 > image_merger.py`. So far, the longest images it has successfully inpainted in my testing were around 150,000 pixels. It fails when I tested it on around 180k px images 🤣. I guess I have to limit the maximum height when merging images 😩.~~ **(fixed)**

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
