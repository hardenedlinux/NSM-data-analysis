{
  description = "hardenedlinux nixpkgs collection";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    zeek-flake = { url = "github:hardenedlinux/zeek-nix"; inputs.flake-utils.follows = "flake-utils"; };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, zeek-flake, flake-compat }:
    {
      python-packages-overlay = import ./nix/python-packages-overlay.nix;
      packages-overlay = import ./nix/packages-overlay.nix;
    }
    //
    (flake-utils.lib.eachSystem [ "x86_64-linux" ]
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.python-packages-overlay
              self.packages-overlay
              self.overlay
              zeek-flake.overlay
            ];
            config = {
              allowUnsupportedSystem = true;
              allowBroken = true;
            };
          };
        in
        rec {
          devShell = with pkgs; mkShell {
            buildInputs = [
              (pkgs.python37.withPackages (ps: with ps;[
                beakerx
                elastalert
                btest
                fastai
                zat
                cefpython3
                pyshark
                tldextract
                yarapython
                python-pptx
                jupyterlab_git
                jupyter_lsp
                fastai
                choochoo
                # cudf ../include/rmm/detail/memory_manager.hpp:37:10: fatal error: rmm/detail/cnmem.h: No such file or directory
                # axelrod pathlib 1.0.1 does not support 3.7
              ]))
              deepsea
              nvdtools
              sybilhunter
              zq
            ];
          };

          packages = {
            inherit (pkgs)
              hardenedlinux-go-env
              hardenedlinux-r-env
              hardenedlinux-python-env
              nvdtools
              broker
              deepsea
              zq
              spicy
              ;
          };

          hydraJobs = {
            inherit packages;
          };

          defaultPackage =
            with pkgs;
            buildEnv rec {
              name = "nixpkgs-hardenedlinux";
              paths = [
                hardenedlinux-go-env
                hardenedlinux-r-env
                hardenedlinux-python-env
              ];
            };
        }
      )
    ) //
    {
      overlay = final: prev: {
        hardenedlinux-go-env = prev.callPackage ./pkgs/go.nix { };
        hardenedlinux-r-env = prev.callPackage ./pkgs/R.nix { };
        hardenedlinux-python-env = prev.callPackage ./pkgs/python.nix { };
      };
    };
}
