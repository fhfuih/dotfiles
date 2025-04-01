# This file contains environments for general, both non-/interactive shells
# shellcheck disable=SC2148

# XDG conventions
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# System-wide configs
# home/bin: for miktex
# home/.local/bin: my own binaries are here
# ~/.pub-cache/bin: for flutter/pub
export PATH="$PATH:$HOME/.local/bin:$HOME/bin:$HOME/.pub-cache/bin"
if [ -d "/opt/homebrew/opt/rustup/bin" ]; then
  export PATH="/opt/homebrew/opt/rustup/bin:$PATH"
fi
if [ -d "/opt/homebrew/opt/openjdk/bin" ]; then
  export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
fi
qt_path=`find ~/Qt -path '*/macos/bin' -type d -depth 3 | head -n 1` && {
  export PATH="${qt_path}:$PATH"
}

if command -v nvim 2>&1 >/dev/null; then
  export VISUAL=nvim
elif command -v vim 2>&1 >/dev/null; then
  export VISUAL=vim
fi
  

# Program configs
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"
export CHKTEXRC="$HOME/.config/chktex"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"

