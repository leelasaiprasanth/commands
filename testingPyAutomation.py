import os
import shutil
from pathlib import Path

def load_dotenv(file_path):
    """Load environment variables from a .env.local file."""
    if os.path.exists(file_path):
        with open(file_path) as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#') and '=' in line:
                    key, value = map(str.strip, line.split('=', 1))
                    os.environ[key] = value
    else:
        print("The .env.local file was not found.")

def copy_files_from_vscode(user_folder_path, destination_path):
    """Copy VSCode configuration files to a destination folder."""
    keybindings_path = os.path.join(user_folder_path, "keybindings.json")
    settings_path = os.path.join(user_folder_path, "settings.json")
    snippets_path = os.path.join(user_folder_path, "snippets")
    
    os.makedirs(destination_path, exist_ok=True)

    if os.path.exists(user_folder_path):
        print(f"User folder found. Copying files to {destination_path}...")
        if os.path.exists(keybindings_path):
            shutil.copy(keybindings_path, destination_path)
        if os.path.exists(settings_path):
            shutil.copy(settings_path, destination_path)
        if os.path.isdir(snippets_path):
            for item in Path(snippets_path).rglob('*'):
                if item.is_file():
                    shutil.copy(item, destination_path)
        print("Files have been copied.")
    else:
        print("User folder not found. Files in the current directory will remain unchanged.")

def copy_files_to_react(source_path, destination_base_path, new_folder_name):
    """Copy files from source path to a new folder in React destination."""
    react_destination_path = os.path.join(destination_base_path, new_folder_name)
    
    os.makedirs(react_destination_path, exist_ok=True)
    
    if os.path.exists(source_path):
        for item in Path(source_path).rglob('*'):
            if item.is_file():
                shutil.copy(item, react_destination_path)
        print(f"Files have been copied to {react_destination_path} with the folder structure preserved.")
    else:
        print("Source folder not found. No files copied.")

def main():
    # Load environment variables from .env.local
    env_file_path = Path.cwd() / ".env.local"
    load_dotenv(env_file_path)
    
    # Verify that the environment variable is set
    source_path = os.getenv('SOURCE_PATH')
    if not source_path:
        print("SOURCE_PATH environment variable is not set. Please check your .env.local file.")
        return
    
    profile_path = Path.home()
    vscode_user_folder_path = profile_path / "AppData/Roaming/Code/User"
    destination_base_path = Path.cwd() / "FrameWorks/React"
    
    # Prompt the user to select an option
    print("Please select an option:")
    print("1: Copy files from VSCode")
    print("2: Copy files to FrameWork/React")
    
    selection = input("Enter your choice (1 or 2): ").strip()
    
    if selection == "1":
        vscode_destination_path = Path.cwd() / "Utils/vscode"
        copy_files_from_vscode(vscode_user_folder_path, vscode_destination_path)
    elif selection == "2":
        new_folder_name = input("Enter the name for the new folder in the React destination: ").strip()
        copy_files_to_react(source_path, destination_base_path, new_folder_name)
    else:
        print("Invalid selection. No action taken.")

if __name__ == "__main__":
    main()
