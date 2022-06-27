# General
export FPATH="$HOME/.zsh_completions:$FPATH"
export PATH="$HOME/.local/bin:$PATH"
export VISUAL=nvim

# rust
. "$HOME/.cargo/env"

# go
export PATH="$HOME/go/bin:$PATH"

# ruby
if which ruby >/dev/null && which gem >/dev/null; then
    export PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi
