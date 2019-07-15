# Zihao’s dotfiles

## Basic Installation

### Using Git and the bootstrap script

```bash
git clone https://github.com/zzh8829/dotfiles.git && cd dotfiles && source dotfiles.sh
```

## Scripts compatibility chart

|             | linux              | macos              | wsl                |
|-------------|--------------------|--------------------|--------------------|
| dotfiles.sh | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| linux.sh    | :heavy_check_mark: |                    | :heavy_check_mark: |
| macos.sh    |                    | :heavy_check_mark: |                    |
| vim.sh      | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| homebrew.sh |                    | :heavy_check_mark: |                    |
| nodejs.sh   | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| go.sh       | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |
| python.sh   | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: |

## Complete Dev Setup (Linux)

```bash
./linux.sh
./dotfiles.sh
```

## Complete Dev Setup (Mac)

```
rsync -av /Volumes/Safe/ssh/mbp/ ~/.ssh/
rsync -av /Volumes/Safe/gnupg/ ~/.gnupg/

xcode-select --install

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

mkdir Repos && cd Repos
git clone git@github.com:zzh8829/dotfiles && cd dotfiles
./dotfiles.sh
./homebrew.sh
./macos.sh
./sublime.sh

gcloud auth login
gcloud components install kubectl
gcloud config set project gcloud
gcloud config set compute/zone us-west1-a
gcloud container clusters get-credentials gk
```
