{
  description = "hardenedlinux nixpkgs collection";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    nvfetcher-flake = {
      url = "github:berberman/nvfetcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicy-flake = { url = "github:GTrunSec/spicy-with-nix-flake"; };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, flake-compat, nvfetcher-flake, spicy-flake }:
    { }
    //
    (flake-utils.lib.eachSystem [ "x86_64-linux" ]
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlay
              nvfetcher-flake.overlay
              spicy-flake.overlay
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
              nixpkgs-fmt
              nvchecker
              (haskellPackages.ghcWithPackages
                (p: with p;  [
                  nvfetcher
                ]))
              (pkgs.python3.withPackages (ps: with ps;[
                btest
              ]))
              zqd
            ];
          };

          packages = {
            inherit (pkgs)
              spicy
              broker
              btest
              zqd
              zat
              elastalert
              ;
            inherit (pkgs.haskellPackages)
              nvfetcher;
          };

          hydraJobs = {
            inherit packages;
          };

          defaultPackage =
            with pkgs;
            buildEnv
              rec {
                name = "nixpkgs-hardenedlinux";
                paths = [ ];
              };
        })
    ) //
    {
      overlay = final: prev:
        let
          sources = (import ./sources.nix) { inherit (final) fetchurl fetchgit; };
          pythonDirNames = builtins.attrNames (builtins.readDir ./packages/python-pkgs);
          pkgsDirNames = builtins.attrNames (builtins.readDir ./packages/pkgs);
        in
        (
          builtins.listToAttrs
            (map
              (pkgDir: {
                value = prev.python3Packages.callPackage (./packages/python-pkgs + "/${pkgDir}") { };
                name = pkgDir;
              })
              pythonDirNames)
        ) //
        (
          builtins.listToAttrs
            (map
              (pkgDir: {
                value = prev.callPackage (./packages/pkgs + "/${pkgDir}") { };
                name = pkgDir;
              })
              pkgsDirNames)
        )
        // { inherit sources; };
    };
}
