# CurrentUserAllHosts: shared setup. Also runs for -Command/-File unless -NoProfile.

# Linux/XDG compatible directories
$env:XDG_CONFIG_HOME = "$HOME/.config"
$env:XDG_DATA_HOME = "$HOME/.local/share"
$env:XDG_STATE_HOME = "$HOME/.local/state"
$env:XDG_CACHE_HOME = "$HOME/.cache"
$env:Path = "$HOME\.local\bin;$env:Path"

# Rust
$env:Path = "$HOME/.cargo/bin;$env:Path"

# Go
$env:Path = "$env:Path;$HOME/go/bin"

# Ruby
if (Get-Command ruby -CommandType Application -ErrorAction SilentlyContinue) {
    $gemUserDir = & ruby -r rubygems -e 'puts Gem.user_dir' 2>$null
    if ($LASTEXITCODE -eq 0 -and $gemUserDir) {
        $env:Path = "$gemUserDir/bin;$env:Path"
    }
}

# JAVA_HOME: retain the Windows JDK/installer setting; macOS java_home does not apply.
