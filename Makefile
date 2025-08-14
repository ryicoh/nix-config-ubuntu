default: install

NIX_ARG := --extra-experimental-features 'nix-command flakes'

install: setup
	-@$(MAKE) profile-remove
	@$(MAKE) profile-add
	@$(MAKE) home-manager

profile-remove: setup
	@nix profile remove `basename $$(pwd)`

profile-add: setup
	@nix profile add . --impure

home-manager: setup
	@nix run nixpkgs#home-manager -- switch --flake .#default

profile-list: setup
	@nix profile list

fmt: setup
	@nix fmt .
# https://nixos.org/download/
install-nix:
	@sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon

setup:
	echo 'experimental-features = nix-command flakes' > ~/.config/nix/nix.conf

setup-xremap:
	sudo gpasswd -a $$USER input

