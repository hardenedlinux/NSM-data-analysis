{
  description = "my project description";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    master.url = "nixpkgs/684d5d27136f154775c95005dcce2d32943c7c9e";
  };

  outputs = inputs@{ self, master, flake-utils }:
    {
      overlay = import ./nix/python-packages-overlay.nix;
    }
    //
    (flake-utils.lib.eachDefaultSystem
        (system:
          let
            pkgs = import master {
              inherit system;
              overlays = [
                self.overlay
          ];
        };
          in
          {
            devShell = import ./shell.nix { inherit pkgs; };
          }
        )
    );
  }
