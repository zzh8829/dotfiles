sudo mkdir -m 0755 /nix && sudo chown $USER /nix
curl https://nixos.org/nix/install | sh

source $HOME/.nix-profile/etc/profile.d/nix.sh

nix-env -i tmux
nix-env -i neovim 
nix-env -i jd