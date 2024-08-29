# Function to load the .env.local file
function Load-DotEnv {
    param (
        [string]$Path
    )

    if (Test-Path $Path) {
        Get-Content $Path | ForEach-Object {
            if ($_ -match '^\s*([^#][^=]+?)\s*=\s*(.+?)\s*$') {
                [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2], [System.EnvironmentVariableTarget]::Process)
            }
        }
    } else {
        Write-Host "The .env.local file was not found."
    }
}

# Load the .env.local file
$envFilePath = Join-Path -Path (Get-Location) -ChildPath ".env.local"
Load-DotEnv -Path $envFilePath

# Verify that the environment variable is set
if (-not $env:SOURCE_PATH) {
    Write-Host "SOURCE_PATH environment variable is not set. Please check your .env.local file."
    exit
}

$profilePath = [System.Environment]::GetFolderPath('UserProfile')

# Prompt the user to select an option
Write-Host "Please select an option:"
Write-Host "1: Copy files from VSCode"
Write-Host "2: Copy files to FrameWork/React"

$selection = Read-Host "Enter your choice (1, 2, or 3)"


switch ($selection) {
    "1" {
        $userFolderPath = Join-Path -Path $profilePath -ChildPath "AppData\Roaming\Code\User"
        $keybindingsPath = Join-Path -Path $userFolderPath -ChildPath "keybindings.json"
        $settingsPath = Join-Path -Path $userFolderPath -ChildPath "settings.json"
        $snippetsPath = Join-Path -Path $userFolderPath -ChildPath "snippets"
        $destinationPath = Join-Path -Path (Get-Location) -ChildPath "Utils\vscode"

        if (-not (Test-Path -Path $destinationPath)) {
            New-Item -Path $destinationPath -ItemType Directory -Force | Out-Null
        }

        if (Test-Path -Path $userFolderPath) {
            Write-Host "User folder found. Copying files to $destinationPath..."
            if (Test-Path -Path $keybindingsPath) {
                Copy-Item -Path $keybindingsPath -Destination $destinationPath -Force
            } if (Test-Path -Path $settingsPath) {
                Copy-Item -Path $settingsPath -Destination $destinationPath -Force
            } if (Test-Path -Path $snippetsPath) {
                Copy-Item -Path "$snippetsPath\*" -Destination $destinationPath -Recurse -Force
            } Write-Host "Files have been copied to $destinationPath"
        } else {
            Write-Host "User folder not found. Files in the current directory will remain unchanged."
        }
    }
    "2" {
        # $sourcePath = Read-Host "Enter the full path of the folder you want to copy"
        # Use the SOURCE_PATH from the .env.local file
        $sourcePath = $env:SOURCE_PATH
        Write-Host "Source path: $env:SOURCE_PATH"

        $destinationBasePath = Join-Path -Path (Get-Location) -ChildPath "FrameWorks\React"
        $newFolderName = Read-Host "Enter the name for the new folder in the React destination"
        $reactDestinationPath = Join-Path -Path $destinationBasePath -ChildPath $newFolderName

        if (-not (Test-Path -Path $reactDestinationPath)) {
            New-Item -Path $reactDestinationPath -ItemType Directory -Force | Out-Null
        }

        if (Test-Path -Path $sourcePath) {
            Copy-Item -Path $sourcePath -Destination $reactDestinationPath -Recurse -Container -Force
            Write-Host "Files have been copied to $reactDestinationPath with the folder structure preserved."
        } else { Write-Host "Source folder not found. No files copied." }
    } Default { Write-Host "Invalid selection. No action taken." }
}