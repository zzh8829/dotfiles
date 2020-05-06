# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Zsh theme
ZSH_THEME="zihao"

# OS Detection
if [[ $(uname) == 'Linux' ]]; then
  export OS=linux
elif [[ $(uname) == 'Darwin' ]]; then
  export OS=macos
elif [[ $(uname -r) == *"Microsoft"* ]]; then
  export OS=wsl
fi

DISABLE_AUTO_TITLE="true"
function precmd () {
  HOSTNAME=$(hostname)
  window_title="\033]0;${HOSTNAME}:${PWD##*/}\007"
  echo -ne "$window_title"
}

# Zsh Plugins
if [[ $OS == 'macos' ]]; then
  plugins=(zsh-autosuggestions extract history colorize sublime docker dotenv)
else
  plugins=(zsh-autosuggestions extract history dotenv)
fi

# User configuration

if [[ $OS == 'wsl' ]]; then
  export ZSH_DISABLE_COMPFIX=true
fi

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8

setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
unsetopt AUTO_CD # Disable cd with folder name
# ======================
# ==     EXPORTS      ==
# ======================

# Path
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# Home bin
export PATH=~/bin:$PATH
export PATH=~/.local/bin:$PATH

# Yarn
if type yarn &> /dev/null; then
  export PATH="$(yarn global bin):$PATH"
fi

# GO
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

if [[ $OS == 'macos' ]]; then
  # LaTeX
  export PATH=$PATH:/usr/texbin:/Library/TeX/texbin

  # Racket
  export PATH=$PATH:/Applications/Racket\ v6.1/bin

  # scripts
  export PATH=$PATH:~/Repos/config/scripts

  # CUDA
  export PATH=$PATH:/usr/local/cuda/bin

  export CLASSPATH=~/Projects/cs241/pub/classes:$CLASSPATH

  export FONTCONFIG_PATH=/opt/X11/lib/X11/fontconfig

  # Link Homebrew casks in `/Applications` rather than `~/Applications`
  export HOMEBREW_CASK_OPTS="--appdir=/Applications";
elif [[ $OS == 'linux' ]]; then
  [[ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]] && source $HOME/.nix-profile/etc/profile.d/nix.sh 
fi

# Virtual Env
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then
  # GNU `ls`
  colorflag="--color"
  export LS_COLORS='di=1;31:ln=36:so=37:pi=1;33:ex=35:bd=37:cd=37:su=37:sg=37:tw=32:ow=32'
else
  # mac `ls`
  colorflag="-G"
  export LSCOLORS='BxgxhxDxfxhxhxhxhxcxcx'
fi

export REPOS="$HOME/Repos"
if [[ $OS == 'macos' ]]; then
  export ICLOUD=/Users/zihao/Library/Mobile\ Documents/com\~apple\~CloudDocs/
  export PROJECTS="$ICLOUD/Projects"
else
  export PROJECTS="$HOME/Projects"
fi

# ====================
# ==     ALIASES    ==
# ====================

if type nvim &> /dev/null; then
  export EDITOR="nvim"
elif type vim &> /dev/null; then
  export EDITOR="vim"
elif type vi &> /dev/null; then
  export EDITOR="vi"
elif type nano &> /dev/null; then
  export EDITOR="nano"
fi

alias vim=$EDITOR
alias vi=$EDITOR

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Easier navigation: .., ..., ...., ....., ~ and -

alias ..="cd .."
alias ...="cd ../.."

# Shortcuts
alias h="history"
alias j="jobs"
alias dl="cd $HOME/Downloads"
alias dt="cd $HOME/Desktop"
alias r="cd $REPOS"
alias p="cd $PROJECTS"

# List all files colorized in long format
alias l="ls -lF ${colorflag}"

# List all files colorized in long format, including dot files
alias la="ls -laF ${colorflag}"

# List only directories
alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"

# Always use color output for `ls`
alias ls="ls ${colorflag}"

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# IP addresses
alias ip4="curl -4 https://icanhazip.com/"
alias ip6="curl -6 https://icanhazip.com/"
if [[ -e /sbin/ifconfig ]]; then
  alias iplocal="ifconfig | grep 'inet ' | awk '{print $2}'"
else
  alias iplocal="ip address | grep 'inet ' | awk '{print $2}'"
fi

# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null || alias hd="hexdump -C"

# macOS has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# macOS has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Ring the terminal bell, and put a badge on Terminal.app’s Dock icon
# (useful when executing time-consuming commands)
alias bell="tput bel"

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $(which zsh) -l"

# Git
alias grim="git rebase -i master"
if type tig &> /dev/null; then
  alias gl=tig
fi
alias gst="git stash"
alias gsp="git stash pop"

# Random stuff
alias t=tmux
alias nb="workon py3 && jupyter notebook"
alias octave="octave --no-gui"
alias dotf="cd ~/.dotfiles && ./dotfiles.sh && cd - && reload"

if [[ $OS == 'macos' ]]; then
  alias s="cd $ICLOUD/Study"

  # Show/hide hidden files in Finder
  alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
  alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

  # Merge PDF files
  # Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
  alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

  # Airport CLI alias
  alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'

  # PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
  alias plistbuddy="/usr/libexec/PlistBuddy"
elif [[ $OS == 'wsl' ]]; then
  alias docker="docker.exe"
  alias docker-compose="docker-compose.exe"
  alias cmd="cmd.exe"
  alias cd="cd -P"
fi

# ====================
# ==   Functions    ==
# ====================

# Use Git’s colored diff when available
if type git &>/dev/null ; then
  function diff() {
    git diff --no-index --color-words "$@";
  }
fi

# Start an HTTP server from a directory, optionally specifying the port
function server() {
  local port="${1:-8000}";
  sleep 1 && open "http://localhost:${port}/" &
  http-server -p $port
}

# Run `dig` and display the most useful info
function digg() {
  dig +nocmd "$1" any +multiline +noall +answer;
}

function pingg() {
  ping -c10 google.com
}

function portquiz() {
  curl portquiz.net:$1
}

function pip-save() {
  local pkg=$1

  if [[ -z "$1" ]]; then
    echo "usage: pip-save <pkg name>"
    return 1
  fi

  local _ins="pip install --upgrade $pkg"
  eval $_ins
  pip freeze | grep $pkg -i >> requirements.txt
}

function pip3-save() {
  local pkg=$1

  if [[ -z "$1" ]]; then
    echo "usage: pip3-save <pkg name>"
    return 1
  fi

  local _ins="pip3 install --upgrade $pkg"
  eval $_ins
  pip3 freeze | grep $pkg -i >> requirements.txt
}

function mksecret() {
  python -c "import random,string;print(''.join([random.SystemRandom().choice(\"{}{}\".format(string.ascii_letters, string.digits)) for i in range(64)]))" | pbcopy;
}

function printpath() {
  echo $PATH | tr ":" "\n"
}

function git-dl() {
  folder=${@/tree\/master/trunk}
  svn export $folder
}

function portl() {
  lsof -nP -iTCP:$1
}

# ====================
# ==     Other      ==
# ====================

# Kubectl completion lazy load
if type kubectl &> /dev/null; then
  function kubectl() {
    if ! type __start_kubectl &> /dev/null; then
      source <(command kubectl completion zsh)
    fi

    command kubectl "$@"
  }
fi

if type scmpuff &> /dev/null; then
  eval "$(scmpuff init -s)"
fi

export GPG_TTY=$(tty)

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --ansi'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
[[ -e ~/.fzf.zsh ]] && source ~/.fzf.zsh

if [[ $OS == 'macos' ]]; then
  if [ -e '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk' ]; then
    source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
    source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
  fi

  # Cuda
  export LD_LIBRARY_PATH=/usr/local/cuda/lib:/usr/local/cuda/extras/CUPTI/lib:/Applications/cuda/lib:$LD_LIBRARY_PATH
elif [[ $OS == "linux" ]]; then
  if [ -e "~/google-cloud-sdk" ]; then
    source "~/google-cloud-sdk/path.zsh.inc"
    source "~/google-cloud-sdk/completion.zsh.inc"
  fi
fi

# Anaconda
[[ -e /usr/local/anaconda3/bin/conda ]] && eval "$('/usr/local/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
[[ -e /usr/local/anaconda3 ]] && . /usr/local/anaconda3/etc/profile.d/conda.sh && conda activate

[[ -e ~/miniconda3/bin/conda ]] && eval "$(~/miniconda3/bin/conda shell.zsh hook)"


# wasmer
export WASMER_DIR="/Users/zihao/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

[[ -e ~/.zshrc_extra ]] && source ~/.zshrc_extra


export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
