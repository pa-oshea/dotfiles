export ZDOTDIR=$HOME/.config/zsh
export STARSHIP_CONFIG=$HOME/.config/zsh/starship.toml

## TODO: find out what is actually needed here
export PATH="$HOME/.local/bin/:~/go/bin:$HOME/.cargo/bin/:$PATH"

. "$HOME/.cargo/env"

if [ -e /home/patrick/.nix-profile/etc/profile.d/nix.sh ]; then . /home/patrick/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
