import os
import sys
from natsort import natsorted
from PIL import Image
from collections import Counter

def combine_images_in_subfolders(input_root_folder):
    """
    Combines all images vertically within each subfolder of the input_root_folder
    and saves the combined image in the corresponding subfolder of the output_root_folder.
    """
    output_root_folder = f"{input_root_folder}_combined"

    if not os.path.exists(output_root_folder):
        os.makedirs(output_root_folder)

    for subdir, _, files in natsorted(os.walk(input_root_folder)):
        if subdir == input_root_folder:
            continue  # Skip the root folder itself

        # Create corresponding output subfolder
        relative_path = os.path.relpath(subdir, input_root_folder)
        output_subdir = os.path.join(output_root_folder, relative_path)
        if not os.path.exists(output_subdir):
            os.makedirs(output_subdir)

        # Get the name of the current subfolder
        subfolder_name = os.path.basename(subdir)

        # Define the output subfolder and combined image path using os.path.join
        output_filename = f"combined_{subfolder_name}.png"  # .jpg dimension support is too limited for long image
        output_path = os.path.join(output_subdir, output_filename)

        # Skip if the combined image already exists in the output subfolder
        if os.path.exists(output_path):
            print(f"  --> Combined image already exists at '{output_path}'. Skipping.")
            continue

        images_to_combine = []
        for file in files:
            if file.lower().endswith(('.png', '.jpg', '.jpeg', '.gif', '.bmp')):
                image_path = os.path.join(subdir, file)
                try:
                    img = Image.open(image_path)
                    images_to_combine.append(img)
                except IOError:
                    print(f"Warning: Could not open image {image_path}. Skipping.")

        if images_to_combine:
            # Sort images by filename for consistent order (optional)
            images_to_combine.sort(key=lambda x: os.path.basename(x.filename))

            widths, heights = zip(*(i.size for i in images_to_combine))
            max_width = max(widths)
            most_common_width, count = Counter(widths).most_common(1)[0]
            total_height = sum(heights)  

            combined_image = Image.new('RGB', (max_width, total_height))

            x_offset = 0
            y_offset = 0
            paste_position = (x_offset, y_offset)

            for img in images_to_combine:
            # Resize images to match the most common width while preserving aspect ratio
                if img.width != most_common_width:
                    aspect_ratio = most_common_width / img.width
                    new_height = int((img.height * aspect_ratio))
                    total_height -= (img.height - new_height) # adjust total height for cropping after resizing width, removing black area
                    img = img.resize((most_common_width, new_height), Image.Resampling.LANCZOS)

                combined_image.paste(img, (x_offset, y_offset))
                y_offset += img.height

                newer_width = paste_position[0] + img.width
                newer_height = total_height

                cropped_region = (paste_position[0], paste_position[1],
                                  newer_width,
                                  newer_height)
            
                final_image = combined_image.crop(cropped_region)

            # Save the combined image
            final_image.save(output_path)
            print(f"Combined images in '{subdir}' and saved to '{output_path}'")
        else:
            print(f"No images found in '{subdir}' to combine.")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        input_root_folder = sys.argv[1]
        combine_images_in_subfolders(input_root_folder)
    else:
        print('Usage: python image-merger_all.py "input path"')