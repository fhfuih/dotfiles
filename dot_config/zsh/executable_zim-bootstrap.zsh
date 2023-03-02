ZIM_HOME=~/.zim
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if which curl; then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  elif which wget; then
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    echo "No curl and wget can be found, skip setup zim" > /dev/stderr
    exit 1
  fi
fi

# Install missing modules,
# and update ${ZIM_HOME}/init.zsh if missing or outdated.
ZIMRC=${ZDOTDIR:-${HOME}}/.zimrc
if [[ ! "${ZIM_HOME}/init.zsh" -nt "$ZIMRC" ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

# Initialize modules.
source ${ZIM_HOME}/init.zsh
