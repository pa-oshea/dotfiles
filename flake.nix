{
  description = "Dev Environment Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system} = {
        # Combine everything for a 'full' install
        default = pkgs.buildEnv {
          name = "my-complete-env";
          paths = (import ./nix/core.nix { inherit pkgs; })
               ++ (import ./nix/java.nix { inherit pkgs; });
        };

        # Just the core tools
        core = pkgs.buildEnv {
          name = "core-env";
          paths = import ./nix/core.nix { inherit pkgs; };
        };

        # Just the Java tools
        java = pkgs.buildEnv {
          name = "java-env";
          paths = import ./nix/java.nix { inherit pkgs; };
        };
      };
    };
}
