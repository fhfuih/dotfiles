# CurrentUserCurrentHost: interactive console setup.

# Interactive shell detection
$profileArgs = [Environment]::GetCommandLineArgs() | Select-Object -Skip 1
$profileNonInteractive = $false
$profileCommandMode = $false
$profileNoExit = $false
foreach ($profileArg in $profileArgs) {
    if ($profileArg -notmatch '^[-/]') { break }
    if ($profileArg -match '^[-/](noni|noninteractive)$') { $profileNonInteractive = $true }
    if ($profileArg -match '^[-/](noe|noexit)$') { $profileNoExit = $true }
    if ($profileArg -match '^[-/](c|command|commandwithargs|f|file|e|ec|enc|encodedcommand)$') {
        $profileCommandMode = $true
        break
    }
}
$profileHasDumbTerm = $env:TERM -eq 'dumb'
$profileInteractive = $Host.Name -eq 'ConsoleHost' -and
    -not $profileNonInteractive -and
    (-not $profileCommandMode -or $profileNoExit) -and
    -not [Console]::IsInputRedirected -and
    -not $profileHasDumbTerm

if (-not $profileInteractive) { return }

### ==========

### Helpers
function global:reload { . $PROFILE.CurrentUserAllHosts; . $PROFILE.CurrentUserCurrentHost }

# Profiles are dot-sourced, so private: alone would still leave the helper in
# the caller's scope. Remove it in finally after initialization completes.
function private:Test-Command {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

### Shell interactivity
Invoke-Expression (&starship init powershell)

Set-PSReadLineOption -EditMode Vi
# if (Get-Module -ListAvailable PSReadLinu) {
    # Import-Module PSReadLine
    # Set-PSReadLineOption -EditMode Vi
    # Set-PSReadLineOption -PredictionSource History # Native history suggestions and syntax highlighting
# }

foreach ($editor in 'nvim', 'vim', 'edit', 'nano', 'code') {
    if (Test-Command $editor) {
        $env:VISUAL = $editor
        break
    }
}

### Third-party command installer and bootstrapper
if (Test-Command mise) {
    # mise 2026.3.5's command-not-found hook reads PSReadLine history before
    # the first prompt. Disable auto-install on missing commands to avoid it.
    $env:MISE_NOT_FOUND_AUTO_INSTALL = 'false'
    (&mise activate pwsh) | Out-String | Invoke-Expression
}

### Auto Completion
if (Get-Module -ListAvailable posh-git) { Import-Module posh-git }

# missing: pip

if (Test-Command uv) {
    (& uv generate-shell-completion powershell | Out-String) | Invoke-Expression
}

# missing: pnpm

if (Test-Command fnm) {
    (& fnm env --shell powershell --fnm-dir="$HOME/.local/share/fnm" --use-on-cd --version-file-strategy=recursive --corepack-enabled --resolve-engines | Out-String) | Invoke-Expression
    (& fnm completions --shell powershell | Out-String) | Invoke-Expression
}

if (Test-Command gh) {
    (& gh completion -s powershell | Out-String) | Invoke-Expression
}

if (Test-Command supabase) {
    (& supabase completion powershell | Out-String) | Invoke-Expression
}

### Non-auto-completion software setup
foreach ($profileVenv in @("$HOME/venv/Scripts/Activate.ps1", "$HOME/.venv/Scripts/Activate.ps1")) {
    if (Test-Path $profileVenv) { . $profileVenv; break }
}

# Keep zoxide after other activation hooks.
if (Test-Command zoxide) {
    (& zoxide init powershell | Out-String) | Invoke-Expression
}
