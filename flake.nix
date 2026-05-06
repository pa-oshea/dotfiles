{
  description = "Dev Environment Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      mkEnv = name: paths: pkgs.buildEnv { inherit name paths; };
    in {
      packages.${system} = {
        default = mkEnv "my-complete-env" (
          import ./nix/core.nix  { inherit pkgs; } ++
          import ./nix/java.nix  { inherit pkgs; } ++
          import ./nix/go.nix    { inherit pkgs; } ++
          import ./nix/rust.nix  { inherit pkgs; } ++
          import ./nix/node.nix  { inherit pkgs; }
        );
        core = mkEnv "core-env"  (import ./nix/core.nix  { inherit pkgs; });
        java = mkEnv "java-env"  (import ./nix/java.nix  { inherit pkgs; });
        go   = mkEnv "go-env"    (import ./nix/go.nix    { inherit pkgs; });
        rust = mkEnv "rust-env"  (import ./nix/rust.nix  { inherit pkgs; });
        node = mkEnv "node-env"  (import ./nix/node.nix  { inherit pkgs; });
      };

      # Project-level shells (nix develop .#rust-project etc.)
      devShells.${system} = {
        rust-project = import ./shells/rust.nix { inherit pkgs; };
        java-project = import ./shells/java.nix { inherit pkgs; };
      };
    };
}
