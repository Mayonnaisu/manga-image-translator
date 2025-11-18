import os
import sys
from PIL import Image
Image.MAX_IMAGE_PIXELS = None
from pathlib import Path
from natsort import natsorted
from collections import Counter

def replace_string_from_folder_name(full_path, string_to_find, string_to_replace):

    parent_dir = os.path.dirname(full_path)
    folder_name = os.path.basename(full_path)

    if string_to_find in folder_name:
        new_folder_name = folder_name.replace(string_to_find, string_to_replace)
        new_full_path = os.path.join(parent_dir, new_folder_name)
        return new_full_path
    else:
        return full_path

def split_images_horizontally(input_root_folder, split_parts, string_to_find, string_to_replace):
    """
    Recursively finds and splits all images horizontally in a folder structure.

    Args:
        input_root_folder (str): The root folder containing images to be split.
        split_parts  (str/int): The number of parts to split
        string_to_find (str): The string to find in folder name
        string_to_replace (str): The string to replace in folder name
    """
    image_extensions = ('jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp')

    # Check if input path exists
    if not os.path.exists(input_root_folder):
        raise Exception(f"The path '{input_root_folder}' does not exist.")
    
    # Check if image even exists at all
    has_images = False
    walker = os.walk(input_root_folder)
    for _, _, files in walker:
        for filename in files:
            if filename.lower().endswith(image_extensions):
                has_images = True
                break
        if has_images:
            break

    if not has_images:
        raise Exception(f"No image files found in any subfolder of '{input_root_folder}'.")

    # Define the output and original root path
    input_root_path = Path(input_root_folder)

    output_root_path = replace_string_from_folder_name(input_root_path, string_to_find, string_to_replace)

    original_root_path = replace_string_from_folder_name(input_root_path, string_to_find, "")

    # Walk through the directory tree
    for dirpath, dirnames, filenames in natsorted(os.walk(input_root_path)):
        current_input_dir = Path(dirpath)
        relative_path = current_input_dir.relative_to(input_root_path)

        image_files = [
            f
            for f in filenames
            if f.lower().endswith(image_extensions)
        ]
        # Skip if there's no image in current directory
        if not image_files:
            continue

        # Get the number of files for the number of parts to split & the commonest extension and mode in the corresponding original path
        current_original_dir = original_root_path / relative_path

        original_image_counts = {}
        original_extensions = []
        original_modes = []
        for p, _, files in natsorted(os.walk(current_original_dir)):
            original_image_files = [
                fl
                for fl in files
                if fl.lower().endswith(image_extensions)
            ]
            # Skip if there's no image in current directory
            if not original_image_files:
                continue

            count = 0
            for file in files:
                if file.lower().endswith(image_extensions):
                    # Get the most common original extension
                    original_extension = file.split('.')[-1].lower()
                    original_extensions.append(original_extension)
                    original_extension_counts = Counter(original_extensions)
                    common_original_extension, counts = original_extension_counts.most_common(1)[0]

                    # Get the most common original mode
                    original_image_path = current_original_dir / file
                    try:
                        with Image.open(original_image_path) as ori_img:
                            original_modes.append(ori_img.mode)
                    except Exception as e:
                        raise Exception(f"Error processing original image '{input_image_path}': {e}")
                    
                    # Get original image count
                    count += 1
            original_image_counts[p] = count
            original_mode_counts = Counter(original_modes)
            common_original_mode, _ = original_mode_counts.most_common(1)[0]

            # Set the number of split parts according to the given argument
            if split_parts.lower() == "original":
                parts = original_image_counts[p]
            else:
                parts = int(split_parts)
                if parts < 1:
                    raise Exception("Number of split parts can't be less than 1!")

        # Create the corresponding output subdirectory structure
        current_output_dir = output_root_path / relative_path
        current_output_dir.mkdir(parents=True, exist_ok=True)

        for filename in filenames:
            file_extension = filename.split('.')[-1].lower()
            # Only process known image file types
            if file_extension in image_extensions:
                input_image_path = current_input_dir / filename

                try:
                    with Image.open(input_image_path) as img:
                        width, height = img.size
                        part_height = height // parts

                        print(f"Processing '{input_image_path}'...")
                        
                        # Split the image into horizontal parts
                        for i in range(parts):
                            # Construct the output filename
                            output_filename = f"image{str(i+1).zfill(2)}.{common_original_extension}"
                            output_image_path = current_output_dir / output_filename

                            # Skip splitting if the output image already exists
                            if output_image_path.exists():
                                print(f"  - Skipped '{output_image_path}' (already exists)")
                                continue

                            # Define the cropping box for each part
                            left = 0
                            upper = i * part_height
                            right = width
                            lower = upper + part_height
                            
                            # For the last part, ensure it includes the remaining pixels
                            if i == parts - 1:
                                lower = height

                            # Convert to the commonest original mode
                            img = img.convert(common_original_mode)

                            # Crop and save
                            cropped_img = img.crop((left, upper, right, lower))
                            
                            cropped_img.save(output_image_path, quality=100)
                            print(f"  - Saved split part to '{output_image_path}'")
                    
                except Exception as e:
                    raise Exception(f"Error processing image '{input_image_path}': {e}")

if __name__ == "__main__":
    if len(sys.argv) > 4:
        input_root_folder = sys.argv[1]
        split_parts = sys.argv[2]
        string_to_find = sys.argv[3]
        string_to_replace = sys.argv[4]
        try:
            split_images_horizontally(input_root_folder, split_parts, string_to_find, string_to_replace)
        except Exception as e:
            print(f"ERROR: {e}", file=sys.stderr)
            sys.exit(1)
    else:
        print('Usage: python image_splitter.py <"input path"> <"original" or number of split parts> <"string to find"> <"string to replace">')
        raise Exception("ERROR: Please provide the 4 arguments! XD")