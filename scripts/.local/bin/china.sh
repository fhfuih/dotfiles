#!/bin/bash

exitChina() {
  sed -i '' -nr -e '/export IS_CHINA/!p' -e '$a\
    unset IS_CHINA' ~/.zprofile ~/.bash_profile ~/.profile

  if which brew >/dev/null; then
    # brew
    unset HOMEBREW_BREW_GIT_REMOTE
    git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew

    unset HOMEBGIT_CORE_GIT_REMOTE
    BREW_TAPS="$(BREW_TAPS="$(brew tap 2>/dev/null)"; echo -n "${BREW_TAPS//$'\n'/:}")"
    for tap in core cask{,-fonts,-drivers,-versions} command-not-found; do
      if [[ ":${BREW_TAPS}:" == *":homebrew/${tap}:"* ]]; then  # 只复原已安装的 Tap
        brew tap --custom-remote "homebrew/${tap}" "https://github.com/Homebrew/homebrew-${tap}"
      fi
    done

    unset HOMEBREW_BOTTLE_DOMAIN
  fi
  brew update
}

enterChina() {
  sed -i '' -nr -e '/unset IS_CHINA/!p' -e '$a\
    export IS_CHINA=true' ~/.zprofile ~/.bash_profile ~/.profile

  if which brew >/dev/null; then
    # brew
    export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
    # brew update

    export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
    BREW_TAPS="$(BREW_TAPS="$(brew tap 2>/dev/null)"; echo -n "${BREW_TAPS//$'\n'/:}")"
    for tap in core cask{,-fonts,-drivers,-versions} command-not-found; do
      if [[ ":${BREW_TAPS}:" == *":homebrew/${tap}:"* ]]; then  # 只复原已安装的 Tap
        brew tap --custom-remote --force-auto-update "homebrew/${tap}" "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-${tap}.git"
      fi
    done

    export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
  fi
  brew update
}

if [ -n "$IS_CHINA" ]; then
  exitChina()
else
  enterChina()
fi

