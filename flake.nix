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
    digga.url = "github:divnix/digga/staging";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, flake-compat, nvfetcher-flake, digga }:
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
              nvchecker
              nix-prefetch-git
              (haskellPackages.ghcWithPackages
                (p: with p;  [
                  nvfetcher
                ]))
              (pkgs.python3.withPackages (ps: with ps;[
                beakerx
              ]))
            ];
          };

          packages = {
            inherit (pkgs)
              beakerx
              elastalert
              spicy
              broker;
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
          inherit (prev) lib;
          sources = (import ./sources.nix) { inherit (final) fetchurl fetchgit; };
          pythonDirNames = lib.attrNames (lib.filterAttrs (pkgDir: type: type == "directory" && builtins.pathExists (./packages/python + "/${pkgDir}/default.nix")) (builtins.readDir ./packages/python));
          pkgsDirNames = lib.attrNames (lib.filterAttrs (pkgDir: type: type == "directory" && builtins.pathExists (./packages/pkgs + "/${pkgDir}/default.nix")) (builtins.readDir ./packages/pkgs));
        in
        (
          builtins.listToAttrs
            (map
              (pkgDir: {
                value = prev.callPackage (./packages/python + "/${pkgDir}") { };
                name = pkgDir;
              })
              pythonDirNames)
        ) //
        (
          builtins.listToAttrs
            (map
              (pkgDir: {
                value = prev.callPackage (./packages/pkgs + "/${pkgDir}") { source = sources.${pkgDir}; };
                name = pkgDir;
              })
              pkgsDirNames)
        )
        // { };
    };
}
