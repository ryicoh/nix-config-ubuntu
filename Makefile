default: install

NIX := nix --extra-experimental-features 'flakes nix-command'


install:
	-@$(MAKE) profile-remove
	@$(MAKE) profile-add

profile-remove:
	@$(NIX) profile remove `basename $$(pwd)`

profile-add:
	@$(NIX) profile add . --impure

profile-list:
	@$(NIX) profile list

fmt:
	@$(NIX) fmt .

# https://nixos.org/download/
setup-nix:
	@sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon

