import os
import shutil
import tempfile
import argparse

HYPE_TEMPLATES_PATH: str = os.path.expanduser('~/Documents/tq-dev/hypes/templates')
DEFAULT_TEMPLATE: str = 'TQH1-Hype-Template'

def prepare(name: str, selected_template: str) -> str:
    """Prepare template files to be modified by creating temp files"""
    print("Preparing order...")
    temp_dir = tempfile.mkdtemp()
    print(f"Created temp folder at {temp_dir}")
    destination_dir = os.path.join(temp_dir, name)
    
    shutil.copytree(selected_template, destination_dir)
    print("Adding some extras...")
    
    for filename in os.listdir(destination_dir):
        if filename.startswith('.'):
            continue
        
        old_path = os.path.join(destination_dir, filename)
        
        if os.path.isfile(old_path):
            base, ext = os.path.splitext(filename)
            if "embed_code" in base.lower():
                continue
            
            new_name = f"{name}{ext}"
        else:
            # Handle .hype and .hyperesources folder
            if "." in filename:
                base, ext = filename.split('.')
                new_name = f"{name}.{ext}"
            else:
                new_name = name
        
        new_path = os.path.join(destination_dir, new_name)
        os.rename(old_path, new_path)

    print("Ready to cook!")
    
    return destination_dir
    

def cook(temp_folder: str, name: str) -> None:
    """Modify temp files with provided data (args)"""
    print("Cooking order...")
    
    for root, _, files in os.walk(temp_folder):
        for filename in files:
            file_path = os.path.join(root, filename)
            
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
            
            new_content = content.replace("&TEMPLATE_NAME", name)
            
            if new_content != content:
                with open(file_path, 'w', encoding='utf-8', errors='ignore') as f:
                    f.write(new_content)
                
    print("Order ready! Time to serve!")
    
def serve(temp_folder: str, name: str, output: str) -> None:
    """Move modified temp files to the destination and clean temp dir"""
    print("Serving order...")
    destination_dir = os.path.join(output, name)
    
    if "~" in destination_dir:
        destination_dir = os.path.expanduser(destination_dir)
    
    if os.path.exists(destination_dir):
        print("Removing dirty dishes...")
        shutil.rmtree(destination_dir)
    
    shutil.copytree(temp_folder, destination_dir, )
    
    if not os.path.exists(destination_dir):
        print("Table not found! Clients must have left while cooking!")
        exit(1)
    
def cleanup(temp_folder: str) -> None:
    shutil.rmtree(temp_folder)
    
def showMenu() -> None:
    print('\nAvailable Hype Templates:\n')
    for file in os.listdir(HYPE_TEMPLATES_PATH):
        if not file.startswith('.'):
            print(f'\t- {file}')
    print('\n')
    
def getOrder() -> tuple[str, str, str]:
    parser = argparse.ArgumentParser(description="CLI utility to create Hype from template")
    
    parser.add_argument('name', nargs='?', help='Name of the hype (usually your jira task ID)')
    parser.add_argument('output', nargs='?', default=os.getcwd(), help='Directory where the files will be saved (current dir by default)')
    parser.add_argument('--template', default=DEFAULT_TEMPLATE, help=f"Template to be used, defaults to '{DEFAULT_TEMPLATE}'")
    parser.add_argument('--list-templates', action='store_true', help=f"Will show a list of the available templates at the designated path ({HYPE_TEMPLATES_PATH})")    
        
    args = parser.parse_args()
    
    if args.list_templates:
        showMenu()
        exit(0)
        
    if not args.name:
        print('Invalid or empty name provided, exiting...')
        exit(1)    

    if not args.output:
        print('There was an error when getting output argument, exiting...')
        exit(1)
    
    if not args.template:
        print('There was an error when getting template argument, exiting...')
        exit(1)
    
    return (args.name, args.output, args.template)
    
def main():
    name, output, template = getOrder()
    selected_template: str = os.path.join(HYPE_TEMPLATES_PATH, template)
    
    if not os.path.exists(selected_template):
        print(f"Template '{selected_template}' does not exist, please provide a valid template")
        exit(1)
    
    print("-"*15)
    print(f"Order:\n\n\t- Name: {name}\n\t- Output: {output}\n\n")
    
    temp_folder: str = prepare(name, selected_template)
    
    try:
        cook(temp_folder, name)
        serve(temp_folder, name, output)
    except Exception as e:
        print(f"Error: {e}")
    finally:
        cleanup(os.path.dirname(temp_folder))
    
    print("-"*15)   
    
    print(f"Order Delivered! ~ Hype '{name}' created from template '{selected_template}' at '{output}'")

if __name__ == '__main__':
    main()