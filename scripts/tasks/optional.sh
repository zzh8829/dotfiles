#!/usr/bin/env bash
# Explicit opt-in tasks, excluded from the Mac profile.
task_conda() {
  local platform architecture
  case "$DF_OS" in Darwin) platform=MacOSX ;; Linux) platform=Linux ;; *) df_die 'Unsupported Miniconda platform.' ;; esac
  architecture=$(uname -m)
  case "$architecture" in arm64) [[ "$DF_OS" == Darwin ]] || architecture=aarch64 ;; x86_64|aarch64) ;; *) df_die 'Unsupported Miniconda architecture.' ;; esac
  if [[ -x "$HOME/miniconda3/bin/conda" ]]; then
    df_log '  Keeping existing Miniconda installation.'
  else
    [[ ! -e "$HOME/miniconda3" && ! -L "$HOME/miniconda3" ]] || df_die 'Existing ~/miniconda3 is incomplete; preserved.'
    df_download_installer "https://repo.anaconda.com/miniconda/Miniconda3-latest-$platform-$architecture.sh" bash -b -p "$HOME/miniconda3"
  fi
}
task_nix() {
  if ! command -v nix-env >/dev/null 2>&1; then
    if [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
      # shellcheck disable=SC1091
      source "$HOME/.nix-profile/etc/profile.d/nix.sh"
    else
      df_download_installer https://nixos.org/nix/install sh
      if [[ "$DF_DRY_RUN" != 1 ]]; then
        df_die 'Nix installed. Open a new terminal and rerun the nix task to install its packages.'
      fi
    fi
  fi
  df_require nix-env
  df_run nix-env -i tmux neovim jd stow
}
task_linux() {
  [[ "$DF_OS" == Linux && "$(uname -m)" == x86_64 ]] || df_die 'Legacy Linux bootstrap supports Linux x86_64 only.'
  df_require sudo
  df_require curl
  local manager
  if command -v apt-get >/dev/null 2>&1; then
    manager=apt
    df_run sudo apt-get update
    df_run sudo apt-get install -yyq software-properties-common build-essential cmake zsh stow
  elif command -v yum >/dev/null 2>&1; then
    manager=yum
    df_run sudo yum update
    df_run sudo yum install zsh git stow
  else
    df_die 'The Linux task requires apt-get or yum.'
  fi
  df_require git
  df_run mkdir -p "$HOME/bin"
  df_clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  df_clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
  if [[ "$DF_DRY_RUN" == 1 ]]; then
    df_log '  Download scmpuff 0.3.0 linux_x64 into a temporary directory and install ~/bin/scmpuff.'
  else
    (
      temporary=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-linux.XXXXXX")
      trap 'rm -rf -- "$temporary"' EXIT
      curl --fail --show-error --location --retry 3 https://github.com/mroth/scmpuff/releases/download/v0.3.0/scmpuff_0.3.0_linux_x64.tar.gz -o "$temporary/scmpuff.tar.gz"
      tar xzf "$temporary/scmpuff.tar.gz" -C "$temporary" scmpuff
      install -m 755 "$temporary/scmpuff" "$HOME/bin/scmpuff"
    )
  fi
  if [[ "$manager" == apt ]]; then
    if ! command -v nvim >/dev/null 2>&1; then
      df_run sudo add-apt-repository -y ppa:neovim-ppa/stable
      df_run sudo apt-get update
      df_run sudo apt-get install -yyq neovim
    fi
    if [[ "$DF_DRY_RUN" == 1 ]]; then
      df_log '  Download ripgrep 0.10.0 amd64.deb to a temporary directory and install with sudo dpkg -i.'
    else
      (
        temporary=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-ripgrep.XXXXXX")
        trap 'rm -rf -- "$temporary"' EXIT
        curl --fail --show-error --location --retry 3 https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep_0.10.0_amd64.deb -o "$temporary/ripgrep.deb"
        sudo dpkg -i "$temporary/ripgrep.deb"
      )
    fi
  else
    df_run sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
    df_run sudo yum -y install ripgrep
  fi
  df_clone https://github.com/tmux-plugins/tpm.git "$HOME/.tmux/plugins/tpm"
}
