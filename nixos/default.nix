{
  flakes,
  nixpkgs,
  home-manager,
  user,
  sops-nix,
  catppuccin,
  aagl-gtk-on-nix,
  ...
}: let
  system = "x86_64-linux";

  commonModules = [
    home-manager.nixosModules.home-manager
    aagl-gtk-on-nix.nixosModules.default
    catppuccin.nixosModules.catppuccin
    sops-nix.nixosModules.sops
    ./configuration.nix
  ];

  nixosBox = arch: base: name:
    base.lib.nixosSystem {
      system = arch;
      specialArgs = {
        inherit flakes user name;
      };
      modules =
        commonModules
        ++ [
          # System configuration
          (./. + "/${name}")

          # Home configuration
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit flakes user;
              };
              users.${user} = {
                imports = [
                  ./common-home.nix
		  (./. + "/${name}/home.nix")
                  catppuccin.homeManagerModules.catppuccin
                ];
              };
            };
          }
        ];
    };
in {
  zeus = nixosBox system nixpkgs "zeus";
}
