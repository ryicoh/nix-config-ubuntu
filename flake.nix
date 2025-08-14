{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      user = "ryicoh";
      pkgs = nixpkgs.legacyPackages.${system};
      systemPackages = [

        pkgs.git
        pkgs.vim

        pkgs.curl

        pkgs.ripgrep
        pkgs.fd

        pkgs.libfido2

      ];
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;

      packages.${system}.default = pkgs.buildEnv {
        name = "default";
        paths = systemPackages;
      };
    };
}
