{
  description = "hardenedlinux nixpkgs collection";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/af787d41a536ccf8f7919e819a53fe476f2b53a7";
    zeek-nix = { url = "github:hardenedlinux/zeek-nix"; flake = false; };
    vast = { url = "github:tenzir/vast"; flake = false; };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, zeek-nix, vast }:
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
              (import (vast + "/nix/overlay.nix"))
            ];
            config = {
              allowUnsupportedSystem = true;
              allowBroken = true;
            };
          };
        in
        {
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
              zeek
              deepsea
              nvdtools
              sybilhunter
              zq
              vast
            ];
          };
          packages = {
            inherit (pkgs)
              zeek
              #vast
              ;
          };
        }
      )
    );
}
