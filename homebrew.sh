#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install dev
brew install asdf
brew install python
brew install poetry
brew install node
brew install tfenv
brew install svn
brew install scmpuff
brew install cmake

# Install some tools
brew install wget
brew install neovim
brew install tmux
brew install tig
brew install p7zip
brew install speedtest_cli
brew install ssh-copy-id
brew install ctags
brew install gpg
brew install tmuxinator
brew install kubectl
brew install ffmpeg

brew install fzf
brew install ripgrep
brew install jq
brew install helm
brew install mosh
brew install stow
brew install clang-format


# Install Cask
brew install --cask visual-studio-code
brew install --cask bettertouchtool
brew install --cask insomnia
brew install --cask docker
brew install --cask macfuse && brew install sshfs
brew install --cask google-cloud-sdk
brew install --cask google-chrome
brew install --cask slack
brew install --cask 1password
brew install --cask discord
brew install --cask spotify
brew install --cask vlc
brew install --cask the-unarchiver
brew install --cask steermouse
brew install --cask secretive

# brew install --cask xquartz
# brew install --cask grandperspective

# brew install --cask swiftdefaultappsprefpane
# brwe install --cask macs-fan-control

# Install developer friendly quick look plugins; see https://github.com/sindresorhus/quick-look-plugins
# brew install --cask qlcolorcode qlstephen qlmarkdown quicklook-json qlimagesize webpquicklook suspicious-package quicklookase qlvideo

# brew tap homebrew/cask-drivers
# brew install --cask logitech-gaming-software
# brew install --cask razer-synapse

# Remove outdated versions from the cellar.
brew cleanup
