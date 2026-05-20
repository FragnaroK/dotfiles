import os
import shutil
import argparse
import tempfile
from PIL import Image
from enum import Enum, auto

ALLOWED_EXT = ('.png', '.jpg', '.jpeg')

class OperationType(Enum):
    FILE = auto()
    FOLDER = auto()

def get_args() -> tuple[str, OperationType, int]:
    """Parse command line arguments"""
    parser = argparse.ArgumentParser(description="CLI utility to optimise images")
    parser.add_argument('path', nargs='?', help='Path to the image file or folder')
    parser.add_argument('--width', type=int, default=1140, help='Desired width of the image(s)')
    args = parser.parse_args()

    if not args.path:
        print("Path not provided! Exiting...")
        exit(1)
    
    if not os.path.exists(args.path):
        print("Provided path does not exist! Exiting...")
        exit(1)
        
    if os.path.isfile(args.path):
        operation_type = OperationType.FILE
    elif os.path.isdir(args.path):
        operation_type = OperationType.FOLDER
    else:
        print("Provided path is neither a file nor a folder! Exiting...")
        exit(1)
        
    return args.path, operation_type, args.width

def optimise_image(image_path: str, output_path: str, desired_width: int) -> None:
    """Optimise a single image to the desired width and save as JPEG or PNG"""
    if not image_path.lower().endswith(ALLOWED_EXT):
        print("Provided file is not a supported image format! Exiting...")
        exit(1)

    with Image.open(image_path) as img:
        base, ext = os.path.splitext(os.path.basename(image_path))
        output_extension = "png" if ext.lower() == ".png" else "jpg"
        output_format = "PNG" if ext.lower() == ".png" else "JPEG"
        output_file_path = os.path.join(output_path, f"{base}.{output_extension}")

        original_width, original_height = img.size
        aspect_ratio = original_height / original_width
        new_height = int(desired_width * aspect_ratio)

        resized_image = img.resize((desired_width, new_height))

        if img.mode in ("RGBA", "LA") or (img.mode == "P" and "transparency" in img.info):
            background = Image.new("RGBA", resized_image.size, (255, 255, 255, 0))
            background.paste(resized_image, (0, 0), resized_image.convert("RGBA"))
            if output_format == "JPEG":
                background = background.convert("RGB")
            background.save(output_file_path, output_format)
        else:
            if output_format == "JPEG" and resized_image.mode != "RGB":
                resized_image = resized_image.convert("RGB")
            resized_image.save(output_file_path, output_format)

        print(f"Optimised and saved: {output_file_path}")

def optimise_images_in_folder(folder_path: str, temp_dir: str, desired_width: int) -> None:
    """Optimise all images in a folder and save them to a temporary directory"""
    for item in os.listdir(folder_path):
        item_path = os.path.join(folder_path, item)
        if os.path.isfile(item_path) and item.lower().endswith(ALLOWED_EXT):
            optimise_image(item_path, temp_dir, desired_width)

def main() -> None:
    """Optimise images to desired resolution and quality"""
    path, operation_type, desired_width = get_args()
    temp_dir = tempfile.mkdtemp()
    print(f"Temporary directory created at: {temp_dir}")

    try:
        if operation_type == OperationType.FILE: 
            optimise_image(path, temp_dir, desired_width)
        elif operation_type == OperationType.FOLDER:
            optimise_images_in_folder(path, temp_dir, desired_width)

        print(f"All images have been optimised and saved to: {temp_dir}")

        final_output_dir = os.path.join(os.getcwd(), 'optimised_images')
        shutil.copytree(temp_dir, final_output_dir, dirs_exist_ok=True, ignore=shutil.ignore_patterns('*.DS_Store'))
        print(f"Optimised images moved to: {final_output_dir}")

    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        print("Cleaning up temporary files...")
        shutil.rmtree(temp_dir)
        print("Cleanup complete.")

if __name__ == "__main__":
    main()