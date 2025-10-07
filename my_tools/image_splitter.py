import os
import sys
from PIL import Image
Image.MAX_IMAGE_PIXELS = None
from pathlib import Path
from collections import Counter
from image_merger import combine_images_in_subfolders

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
    """
    image_extensions = ('jpg', 'jpeg', 'png', '.gif', 'bmp')

    # Check if input path exists
    if not os.path.exists(input_root_folder):
        raise Exception(f"The path '{input_root_folder}' does not exist.")
    
    # Check if image even exists at all
    has_images = False
    walker = os.walk(input_root_folder)
    # try:
    #     next(walker)
    # except StopIteration:
    #     pass
    
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
    for dirpath, dirnames, filenames in os.walk(input_root_path):
        current_input_dir = Path(dirpath)
        relative_path = current_input_dir.relative_to(input_root_path)

        # Get the number of files in the corresponding original path for the number of parts to split
        current_original_dir = original_root_path / relative_path

        image_counts = {}
        original_extensions = []
        for p, _, files in os.walk(current_original_dir):
            # Skip the root directory itself
            # if p == current_original_dir:
            #     continue

            count = 0
            for file in files:
                # Get the most common original extension
                original_extension = file.split('.')[-1].lower()
                original_extensions.append(original_extension.lower())
                extension_counts = Counter(original_extensions)
                most_extension, count = extension_counts.most_common(1)[0]

                if file.lower().endswith(image_extensions):
                    count += 1
            image_counts[p] = count

            # Set the number of split parts according to the given argument
            if split_parts.lower() == "original":
                parts = image_counts[p]
            else:
                parts = int(split_parts)
                if parts < 1:
                    raise Exception("Number of split parts can't be less than 1!")

        # Raise error if original path is empty
        # if parts == 0:
        #     raise Exception(f"Can't split into the number of parts as the original images in '{original_root_path}' since it's empty.")

        # Create the corresponding output subdirectory structure
        current_output_dir = output_root_path / relative_path
        # Create the output subfolder only if the input path isn't single folder
        if dirpath != current_input_dir:
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
                            output_filename = f"image{str(i+1).zfill(2)}.{most_extension}"
                            output_image_path = current_output_dir / output_filename

                            # Supports for single folder processing
                            if dirpath == current_input_dir:
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

                            img = img.convert('RGB') # Convert mode to support .jpg conversion
                            cropped_img = img.crop((left, upper, right, lower))
                            
                            cropped_img.save(output_image_path)
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