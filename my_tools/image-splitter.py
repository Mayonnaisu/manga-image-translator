import os
import sys
from PIL import Image
from pathlib import Path

def replace_string_from_folder_name(full_path, string_to_find, string_to_replace):

    parent_dir = os.path.dirname(full_path)
    folder_name = os.path.basename(full_path)

    if string_to_find in folder_name:
        new_folder_name = folder_name.replace(string_to_find, string_to_replace)
        new_full_path = os.path.join(parent_dir, new_folder_name)
        return new_full_path
    else:
        return full_path

def split_images_horizontally(input_root_folder):
    """
    Recursively finds and splits all images horizontally in a folder structure.

    Args:
        input_root_folder (str): The root folder containing images to be split.
    """
    image_extensions = ('jpg', 'jpeg', 'png', '.gif', 'bmp')

    input_root_path = Path(input_root_folder)

    output_root_path = replace_string_from_folder_name(input_root_path, "_combined-translated", "-translated")

    original_root_path = replace_string_from_folder_name(input_root_path, "_combined-translated", "")

    # Walk through the directory tree
    for dirpath, dirnames, filenames in os.walk(input_root_path):
        current_input_dir = Path(dirpath)
        relative_path = current_input_dir.relative_to(input_root_path)

        # Get the number of files in the corresponding original path for the number of parts to split
        current_original_dir = original_root_path / relative_path

        image_counts = {}
        for p, _, files in os.walk(current_original_dir):
            if p == current_original_dir:
                continue

            count = 0
            for file in files:
                if file.lower().endswith(image_extensions):
                    count += 1
            image_counts[p] = count

            parts = image_counts[p]

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
                            output_filename = f"image{str(i+1).zfill(2)}.{file_extension}"
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

                            cropped_img = img.crop((left, upper, right, lower))
                            
                            cropped_img.save(output_image_path)
                            print(f"  - Saved split part to '{output_image_path}'")
                    
                except Exception as e:
                    print(f"Error processing image '{input_image_path}': {e}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        input_root_folder = sys.argv[1]
        split_images_horizontally(input_root_folder)
    else:
        print('Usage: python image-splitter.py "input path"')