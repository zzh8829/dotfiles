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
```
