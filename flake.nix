{
  description = "hardenedlinux nixpkgs collection";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/684d5d27136f154775c95005dcce2d32943c7c9e";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils }:
    {
      python-packages-overlay = import ./nix/python-packages-overlay.nix;
      packages-overlay = import ./nix/packages-overlay.nix;
    }
    //
    (flake-utils.lib.eachDefaultSystem
        (system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                self.python-packages-overlay
                self.packages-overlay
          ];
        };
          in
          {
            devShell = import ./shell.nix { inherit pkgs; };
          }
        )
    );
  }
