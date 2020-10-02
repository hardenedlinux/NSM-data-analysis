{
  description = "hardenedlinux nixpkgs collection";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/302ef60620d277fc87a8aa58c5c561b62c925651";
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
