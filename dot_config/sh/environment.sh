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
export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/.pub-cache/bin"
export VISUAL=nvim

# Program configs
export CHKTEXRC="$HOME/.config/chktex"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"
