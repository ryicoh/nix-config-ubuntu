{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      user = "ryicoh";
      #   pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      systemPackages = [

        pkgs.git
        pkgs.vim
        pkgs.tmux

        pkgs.curl

        pkgs.xsel
        pkgs.fcitx5-mozc
        pkgs.xremap

        pkgs.ripgrep
        pkgs.fd

        pkgs.libfido2

        pkgs.go
        pkgs.gotools
        pkgs.nodejs_24
        pkgs.pnpm
        pkgs.yarn
        pkgs.terraform

        pkgs.gcc

        pkgs.google-cloud-sdk
      ];
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;

      packages.${system}.default = pkgs.buildEnv {
        name = "default";
        paths = systemPackages;
      };

      homeConfigurations = {
        default = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            {
              home.stateVersion = "25.05";
              home.username = user;
              home.homeDirectory = "/home/${user}";

              home.file."/home/${user}/.config/systemd/user/xremap.service" = {
                source = ./xremap.service;
                force = true;
              };
              home.file."/home/${user}/.config/xremap/config.yaml" = {
                source = ./xremap_config.yaml;
                force = true;
              };

              home.file."/home/${user}/.config/mozc/ibus_config.textproto" = {
                source = ./ibus_config.textproto;
                force = true;
              };

              home.file."/home/${user}/.gitconfig" = {
                source = ./gitconfig;
                force = true;
              };

              home.file."/home/${user}/.tmux.conf" = {
                source = ./tmux.conf;
                force = true;
              };

            }
          ];
        };
      };
    };
}
