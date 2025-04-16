{
  description = "Main Flake";

  inputs = {
    # Nixpkgs
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    };
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
    sops-nix.url = "github:Mic92/sops-nix";

    aagl-gtk-on-nix = {
        url = "github:ezKEa/aagl-gtk-on-nix/release-24.11";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    foundryvtt.url = "github:reckenrode/nix-foundryvtt";
  };

  outputs = {
    self,
    nixpkgs,
    unstable,
    home-manager,
    sops-nix,
    catppuccin,
    aagl-gtk-on-nix,
    foundryvtt,
    ...
  } @ flakes: let
    user = "fer";
  in {
    nixosConfigurations = (
      import ./nixos {
        inherit (nixpkgs) lib;
        inherit flakes nixpkgs unstable home-manager aagl-gtk-on-nix sops-nix user catppuccin foundryvtt;
      }
    );
  };
}
