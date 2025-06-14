{
  description = "Nix Configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dots = {
      url = "github:Talha-Ak/nvim-config";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      caelid = nixpkgs.lib.nixosSystem {
        modules = [
          ./nixos/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      "talha@caelid" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs;};
        modules = [./home/nixos.nix];
      };
      "talha@limgrave" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs;};
        modules = [./home/wsl.nix];
      };
    };
  };
}
