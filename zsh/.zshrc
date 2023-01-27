# vim: foldmethod=marker foldmarker=>>>,<<<

export IS_INTERACTIVE="1"

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# alias
alias cur="cd OneDrive\\ -\\ HKUST\\ Connect/Curriculum"
alias p="ALL_PROXY=socks5://localhost:7890"
alias gi="git-ignore"
alias s="kitty +kitten ssh"

# >>> zinit >>>
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# My own plugin config
zinit light zdharma-continuum/history-search-multi-word
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light spaceship-prompt/spaceship-prompt
zinit load esc/conda-zsh-completion
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode
zinit light wtsnjp/texlive-completions
zinit light laggardkernel/git-ignore

# <<< zinit <<<

if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi


# spaceship prompt
export SPACESHIP_EXEC_TIME_SHOW=false
eval spaceship_vi_mode_enable

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/mambaforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/mambaforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# >>> pip autocompletion >>>
__pip_setup="$('pip' 'completion' '--zsh' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__pip_setup"
fi
# <<< end <<<

# >>> brew autojump >>>
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
# <<< brew autojump <<<


autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /Users/zeyu/go/bin/gocomplete go
