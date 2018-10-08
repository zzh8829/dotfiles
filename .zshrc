# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="zihao"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
if [[ "$OSTYPE" == "darwin"* ]]; then
	plugins=(sublime zsh-autosuggestions docker kubectl extract colorize)
else
	plugins=(zsh-autosuggestions extract)
fi

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

if [[ $(uname -r) = *"Microsoft"* ]]; then
  export ZSH_DISABLE_COMPFIX=true
fi

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# ======================
# ==      Exports     ==
# ======================

# Default Path
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH

if [[ "$OSTYPE" == "darwin"* ]]; then
	# LaTeX
	export PATH=$PATH:/usr/texbin:/Library/TeX/texbin

	# Racket
	export PATH=$PATH:/Applications/Racket\ v6.1/bin

  # scripts
  export PATH=$PATH:~/Repos/config/scripts

	# CUDA
	export PATH=$PATH:/usr/local/cuda/bin

	# Homebrew
	export PATH=/usr/local/sbin:$PATH

  # Anaconda
  # export PATH="$PATH":/usr/local/anaconda3/bin

	# Link Homebrew casks in `/Applications` rather than `~/Applications`
	export HOMEBREW_CASK_OPTS="--appdir=/Applications";

	export CLASSPATH=~/Projects/cs241/pub/classes:$CLASSPATH

	export FONTCONFIG_PATH=/opt/X11/lib/X11/fontconfig
fi

# Node Modules
export PATH='./node_modules/.bin':$PATH

# Home bin
export PATH=~/bin:$PATH

export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

export VIRTUALENVWRAPPER_PYTHON=$(which python3)
[ -s "/usr/local/bin/virtualenvwrapper.sh" ] && source /usr/local/bin/virtualenvwrapper.sh
export VIRTUAL_ENV_DISABLE_PROMPT=1


# ====================
# ==     ALIASES    ==
# ====================

# Easier navigation: .., ..., ...., ....., ~ and -

alias ..="cd .."
alias ...="cd ../.."

# Shortcuts
alias h="history"
alias j="jobs"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias p="cd /Users/zihao/Library/Mobile\ Documents/com\~apple\~CloudDocs/Projects"
export PROJECTS=/Users/zihao/Library/Mobile\ Documents/com\~apple\~CloudDocs/Projects
alias r="cd ~/Repos"
alias pd="cd /Volumes/Data/Projects"
alias s="cd /Users/zihao/Library/Mobile\ Documents/com\~apple\~CloudDocs/Study"

alias grim="git rebase -i master"
alias octave="octave --no-gui"

alias dotfiles="cd ~/Repos/dotfiles && ./dotfiles.sh && cd -"

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then
  # GNU `ls`
	colorflag="--color"
	export LS_COLORS='di=1;31:ln=1;31:so=37:pi=1;33:ex=35:bd=37:cd=37:su=37:sg=37:tw=32:ow=32'
else
	# macOS `ls`
	colorflag="-G"
	export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
fi

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

# Enable aliases to be sudo’ed
alias sudo='sudo '

# IP addresses
alias ip4="curl -4 https://icanhazip.com/"
alias ip6="curl -6 https://icanhazip.com/"

if [ -f /sbin/ifconfig ]; then
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

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Merge PDF files
# Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

# PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
alias plistbuddy="/usr/libexec/PlistBuddy"

# Airport CLI alias
alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'

# Ring the terminal bell, and put a badge on Terminal.app’s Dock icon
# (useful when executing time-consuming commands)
alias bell="tput bel"

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

# ====================
# ==   Functions    ==
# ====================

# Use Git’s colored diff when available
hash git &>/dev/null;
if [ $? -eq 0 ]; then
  function diff() {
    git diff --no-index --color-words "$@";
  }
fi;

# Start an HTTP server from a directory, optionally specifying the port
function server() {
  local port="${1:-8000}";
  sleep 1 && open "http://localhost:${port}/" &
  # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
  # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
  python2.7 -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port";
}

# Run `dig` and display the most useful info
function digg() {
  dig +nocmd "$1" any +multiline +noall +answer;
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
  tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

function pingtest() {
  ping -c20 google.com
}

function pip-save() {
    local pkg=$1

    if [ -z "$1" ]; then
        echo "usage: pips <pkg name>"
        return 1
    fi

    local _ins="pip install $pkg"
    eval $_ins
    pip freeze | grep $pkg -i >> requirements.txt
}

mksecret() {
  python -c "import random,string;print(''.join([random.SystemRandom().choice(\"{}{}\".format(string.ascii_letters, string.digits)) for i in range(64)]))" | pbcopy;
}

# ====================
# ==     Other      ==
# ====================

if [[ "$OSTYPE" == "darwin"* ]]; then
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
fi

if [[ $(uname -r) = *"Microsoft"* ]]; then
  alias docker="docker.exe"
  alias docker-compose="docker-compose.exe"
  alias cmd="cmd.exe"
  alias cd="cd -P"
fi

if type scmpuff &> /dev/null; then
  eval "$(scmpuff init -s)"
fi

if type tig &> /dev/null; then
  alias gl=tig
fi

export GPG_TTY=$(tty)

if [[ "$OSTYPE" == "darwin"* ]]; then
  export LD_LIBRARY_PATH=/usr/local/cuda/lib:/usr/local/cuda/extras/CUPTI/lib:/Applications/cuda/lib:$LD_LIBRARY_PATH
fi

alias nb="workon py3 && jupyter notebook"

if [ -e "~/.virtualenvs/py3/bin/activate" ]; then
  source ~/.virtualenvs/py3/bin/activate
fi

alias t=tmux
alias gst="git stash"
alias gsa="git stash apply"
alias gsp="git stash pop"

