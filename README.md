# Zihao’s dotfiles

## Basic Installation

### Using Git and the bootstrap script

```bash
git clone https://github.com/zzh8829/dotfiles.git && cd dotfiles && source dotfiles.sh
```
## Complete Dev Setup

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

git clone https://github.com/zzh8829/dotfiles.git && cd dotfiles
./dotfiles.sh
./homebrew.sh
./osx.sh
./sublime.sh

cp -r /Volumes/Safe/gnupg/* ~/.gnupg
cp -r /Volumes/Safe/ssh/* ~/.ssh

gcloud auth login
gcloud components install kubectl
gcloud config set project gcloud
gcloud config set compute/zone us-west1-a
gcloud container clusters get-credentials gk
```
