# Environments
$env:XDG_CONFIG_HOME = "$HOME/.config"
$env:XDG_DATA_HOME = "$HOME/.local/share"
$env:XDG_STATE_HOME = "$HOME/.local/state"
$env:XDG_CACHE_HOME = "$HOME/.cache"

# Path
$env:Path = "$HOME\.local\bin;$env:Path"

# Shell
Invoke-Expression (&starship init powershell)

# Completions
Import-Module posh-git
