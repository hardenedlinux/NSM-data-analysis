{
  description = "hardenedlinux nixpkgs collection";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/release-21.05";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    nvfetcher = {
      url = "github:berberman/nvfetcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicy = { url = "github:GTrunSec/spicy-with-nix-flake"; };
    devshell-flake = { url = "github:numtide/devshell"; };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, flake-compat, devshell-flake, nvfetcher, spicy }:
    { }
    //
    (flake-utils.lib.eachSystem [ "x86_64-linux" ]
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlay
              nvfetcher.overlay
              spicy.overlay
              devshell-flake.overlay
            ];
            config = {
              allowUnsupportedSystem = true;
              allowBroken = true;
            };
          };
        in
        rec {
          devShell = with pkgs; devshell.mkShell {
            commands = [
              {
                name = pkgs.nvfetcher-bin.pname;
                help = pkgs.nvfetcher-bin.meta.description;
                command = "cd $DEVSHELL_ROOT/packages; ${pkgs.nvfetcher-bin}/bin/nvfetcher -c ./sources.toml --no-output $@; nixpkgs-fmt _sources";
              }
            ];
            packages = [
              nixpkgs-fmt
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
          nixpkgs-hardenedlinux-sources = (import ./packages/_sources/generated.nix) {
            inherit (final) fetchurl fetchgit;
          };
          pythonDirNames = builtins.attrNames
            (builtins.readDir ./packages/python-pkgs);
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
        // { inherit nixpkgs-hardenedlinux-sources; };
    };
}
