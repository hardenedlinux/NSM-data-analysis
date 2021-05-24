{
  description = "hardenedlinux nixpkgs collection";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    nvfetcher.url = "github:berberman/nvfetcher";
    packages = { url = "path:./packages"; inputs.nixpkgs.follows = "nixpkgs"; };
    digga.url = "github:divnix/digga/staging";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, packages, flake-compat, nvfetcher, digga }:
    { }
    //
    (flake-utils.lib.eachSystem [ "x86_64-linux" ]
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              packages.overlay
              self.overlay
              nvfetcher.overlay
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
              (haskellPackages.ghcWithPackages (p: [ p.nvfetcher ]))
              (pkgs.python3.withPackages (ps: with ps;[
                beakerx
              ]))
            ];
          };

          packages = {
            inherit (pkgs)
              beakerx
              elastalert
              spicy;
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
                value = prev.callPackage (./packages/pkgs + "/${pkgDir}") { };
                name = pkgDir;
              })
              pkgsDirNames)
        )
        // { };
    };
}
