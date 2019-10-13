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
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install dev
brew install python
brew install node

# Install some tools
brew install wget
brew install neovim
brew install tmux
brew install tig
brew install p7zip
brew install speedtest_cli
brew install ssh-copy-id
brew install ctags
brew install scmpuff
brew install gpg
brew install kubectl
brew install ffmpeg
brew install cmake
brew install fzf
brew install ripgrep
brew install jq
brew install kubernetes-helm
brew install mosh
brew install stow
brew install youtube-dl

# Install Cask
brew tap caskroom/cask

brew cask install visual-studio-code
brew cask install xquartz
brew cask install bettertouchtool
brew cask install postman
brew cask install docker
brew cask install osxfuse && brew install sshfs
brew cask install google-cloud-sdk

brew cask install google-chrome
brew cask install slack
brew cask install 1password
brew cask install skim
brew cask install discord
brew cask install spotify
brew cask install vlc
brew cask install the-unarchiver
brew cask install grandperspective
brew cask install scroll-reverser

# Install developer friendly quick look plugins; see https://github.com/sindresorhus/quick-look-plugins
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlimagesize webpquicklook suspicious-package quicklookase qlvideo

brew tap homebrew/cask-drivers
brew cask install logitech-gaming-software

# Remove outdated versions from the cellar.
brew cleanup
