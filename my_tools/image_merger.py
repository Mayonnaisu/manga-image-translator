import os
import sys
from PIL import Image
Image.MAX_IMAGE_PIXELS = None
from natsort import natsorted
from collections import Counter

def combine_images_in_subfolders(input_root_folder, output_root_folder, parts):
    """
    Combines images vertically within each subfolder of the input_root_folder
    into a specific number of parts and saves the combined image in the
    corresponding subfolder of the output_root_folder.

    Args:
        input_root_folder (str): The root directory containing image subfolders.
        output_root_folder (str): The root directory where the processed images will be saved.
        parts (int): The number of combined image parts to create for each subfolder.
    """
    if parts <= 0:
        raise Exception("Number of merged images can't be less than 1!")

    image_extensions = ('.png', '.jpg', '.jpeg', '.gif', '.bmp')

    # Check if input path exists
    if not os.path.exists(input_root_folder):
        raise Exception(f"The path '{input_root_folder}' does not exist.")
    
    # Check if image even exists at all
    has_images = False
    walker = os.walk(input_root_folder)
    try:
        next(walker)
    except StopIteration:
        pass
    
    for _, _, files in walker:
        for filename in files:
            if filename.lower().endswith(image_extensions):
                has_images = True
                break
        if has_images:
            break

    if not has_images:
        raise Exception(f"No image files found in any subfolder of '{input_root_folder}'.")

    # Create the output root folder if it doesn't exist
    os.makedirs(output_root_folder, exist_ok=True)

    # Walk through all subfolders in the input root directory
    for dirpath, dirnames, filenames in natsorted(os.walk(input_root_folder)):
        # Skip the root directory itself
        if dirpath == input_root_folder:
            continue

        # Get the subfolder name and create the corresponding output directory
        subfolder_name = os.path.basename(dirpath)
        output_subfolder = os.path.join(output_root_folder, subfolder_name)
        os.makedirs(output_subfolder, exist_ok=True)

        # Filter for image files
        image_files = [
            f
            for f in filenames
            if f.lower().endswith(image_extensions)
        ]
        natsorted(image_files) # Sort to ensure consistent order

        if not image_files:
            print(f"No images found in '{subfolder_name}'. Skipping.")
            continue

        # Divide images into parts
        total_images = len(image_files)
        # Handle cases where the number of images is less than 'parts'
        images_per_part = (total_images + parts - 1) // parts

        for i in range(parts):
            start_index = i * images_per_part
            end_index = start_index + images_per_part

            # Slice the image list for the current part
            part_images = image_files[start_index:end_index]

            if not part_images:
                continue

            # Define the output filename and path
            output_filename = f"{subfolder_name}_merged_{i+1}.png"
            output_path = os.path.join(output_subfolder, output_filename)

            # Skip if the combined image already exists in the output subfolder
            if os.path.exists(output_path):
                print(f"  --> Merged image already exists at '{output_path}'. Skipping.")
                continue

            # Load images for the current part
            loaded_images = []
            for img_file in part_images:
                try:
                    img_path = os.path.join(dirpath, img_file)
                    loaded_images.append(Image.open(img_path))
                except Exception as e:
                    print(f"Could not open image '{img_path}': {e}")

            if not loaded_images:
                continue

            # Find the commonest width and total height for the combined image
            widths, heights = zip(*(img.size for img in loaded_images))
            max_width = max(widths)
            most_common_width, count = Counter(widths).most_common(1)[0]
            total_height = sum(heights)

            x_offset = 0
            y_offset = 0
            paste_position = (x_offset, y_offset)

            # Create a new blank canvas
            combined_image = Image.new(
                "RGB", (most_common_width, total_height), (255, 255, 255)
            )

            for img in loaded_images:
            # Resize images to match the most common width while preserving aspect ratio
                if img.width != most_common_width:
                    aspect_ratio = most_common_width / img.width
                    new_height = int((img.height * aspect_ratio))
                    total_height -= (img.height - new_height) # adjust total height for cropping after resizing width, removing black area
                    img = img.resize((most_common_width, new_height), Image.Resampling.LANCZOS)

                # Paste images onto the canvas
                combined_image.paste(img, (x_offset, y_offset))
                y_offset += img.height

                # Crop images
                newer_width = x_offset + img.width
                newer_height = total_height

                cropped_region = (paste_position[0], paste_position[1],
                                  newer_width,
                                  newer_height)
            
                final_image = combined_image.crop(cropped_region)

            # Save the combined image
            final_image.save(output_path)

            print(f"Merged {len(part_images)} Images & Saved into '{output_path}'.")

if __name__ == "__main__":
    if len(sys.argv) > 2:
        input_root_folder = sys.argv[1]
        output_root_folder = f"{input_root_folder}_merged"
        parts = int(sys.argv[2])
        try:
            combine_images_in_subfolders(input_root_folder, output_root_folder, parts)
        except Exception as e:
            print(f"ERROR: {e}", file=sys.stderr)
            sys.exit(1)
    else:
        print('Usage: python image_merger.py <"input path"> <number of merged images>')
        raise Exception("ERROR: Please provide the 2 arguments!")