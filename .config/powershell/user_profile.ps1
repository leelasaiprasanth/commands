# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

echo "======== Util =========="
echo "ReverHistory - Ctrl+r "
echo "Provider - Ctrl+f "
echo "Deletion Chart - Ctrl+d "
echo "navigate using z "
echo "========================"

Import-Module posh-git
$omp_config = Join-Path $PSScriptRoot ".\pwsh.omp.json"
oh-my-posh --init --shell pwsh --config $omp_config | Invoke-Expression

Import-Module -Name Terminal-Icons

# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History

# Fzf
 Import-Module PSFzf
 Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Env
$env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"

# Alias
Set-Alias -Name vim -Value nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'

# Functions
function gh { Set-Location -LiteralPath "D:\Library\Github Repository" }

function gcom {
     git add .
     git commit -m "$args"
 }
function lazyg {
     git add .
     git commit -m "$args"
     git push
 }
function touch($file) {
     "" | Out-File $file -Encoding ASCII
 }

# Utilities
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

