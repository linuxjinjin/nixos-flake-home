{
  description = "My Home for NixOS";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.05";
    home-manager = {
      url = github:nix-community/home-manager/release-23.05;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        jrk = lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jrk = {
                imports = [ ./home.nix ];
              };
            }
          ];
        };
      };
      homeConfigurations.jrk = home-manager.lib.homeManagerConfiguration { 
        inherit system pkgs;
        homeDirectory = "/home/jrk";
        username = "jrk";
        stateVersion = "23.05";
        configuration = {
          imports = [
            ./home.nix
          ];
        };
      };
    };
}
