#!/usr/bin/env bash

set -e

mkdir -p ~/bin

# zsh
OMZSH_TMP=$(mktemp)
curl -Lo $OMZSH_TMP https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
rm -rf ~/.oh-my-zsh
sh $OMZSH_TMP --unattended
rm $OMZSH_TMP

# zsh autosuggestions
rm -rf ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# zsh permission
chmod 755 /usr/local/share/zsh
chmod 755 /usr/local/share/zsh/site-functions

# scmpuff
SCMPUFF_TMP=$(mktemp -d)
SCMPUFF_VER=0.3.0
SCMPUFF_TAR=scmpuff_${SCMPUFF_VER}_mac_x64

curl -L https://github.com/mroth/scmpuff/releases/download/v$SCMPUFF_VER/$SCMPUFF_TAR.tar.gz | tar xzv -C $SCMPUFF_TMP
mv $SCMPUFF_TMP/scmpuff ~/bin
rm -rf $SCMPUFF_TMP

# tmux
mkdir -p ~/.tmux/plugins
rm -rf ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `osxprep.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Step 1: Update the OS and Install Xcode Tools
echo "------------------------------"
echo "Updating OSX.  If this requires a restart, run the script again."
# Install all available updates

sudo softwareupdate -ia --verbose || true
# Install only recommended available updates
#sudo softwareupdate -irv

echo "------------------------------"

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Menu bar
defaults write com.apple.systemuiserver menuExtras -array \
    "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
    "/System/Library/CoreServices/Menu Extras/AirPlay.menu" \
    "/System/Library/CoreServices/Menu Extras/Battery.menu" \
    "/System/Library/CoreServices/Menu Extras/Clock.menu" \
    "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
    "/System/Library/CoreServices/Menu Extras/Volume.menu" \


defaults write .GlobalPreferences com.apple.mouse.scaling -1

## Finder

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

## VS Code
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false

# Enable Firewall
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

# Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1


for app in "Activity Monitor" "Dock" "Finder" "SystemUIServer"; do
	sudo killall "${app}" > /dev/null 3>&1 || true
done

echo "Done (some change requires logout)"
echo "------------------------------"
