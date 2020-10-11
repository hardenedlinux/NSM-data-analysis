{
  description = "hardenedlinux nixpkgs collection";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/302ef60620d277fc87a8aa58c5c561b62c925651";
    zeek-nix = { url = "github:hardenedlinux/zeek-nix"; flake = false;};
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, zeek-nix}:
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
                (import (zeek-nix + "/overlay.nix"))
              ];
              config = { allowUnsupportedSystem = true;
                         allowBroken = true;};
            };
           in
            {
              devShell = import ./shell.nix { inherit pkgs;};
          }
        )
    );
  }
