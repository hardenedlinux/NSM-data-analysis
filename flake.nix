{
  description = "A highly awesome system configuration.";

  inputs = {
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/staging";
    nixpkgs.url = "nixpkgs/release-21.05";
    nvfetcher = {
      url = "github:berberman/nvfetcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    spicy = { url = "github:GTrunSec/spicy-with-nix-flake"; };
    devshell-flake = { url = "github:numtide/devshell"; flake = false; };
  };


  outputs = inputs@{ self, nixpkgs, utils, flake-compat, nvfetcher, spicy, devshell-flake }:
    let
      inherit (utils.lib.exporters) internalOverlays fromOverlays modulesFromList;
    in
    utils.lib.systemFlake {
      inherit self inputs;

      channels.nixpkgs.input = nixpkgs;
      channelsConfig = {
        allowUnsupportedSystem = true;
        allowBroken = true;
        allowUnfree = true;
      };
      sharedOverlays = [
        self.overlay
        nvfetcher.overlay
        (import "${devshell-flake}/overlay.nix")
      ];

      # export overlays automatically for all packages defined in overlaysBuilder of each channel
      overlays = internalOverlays {
        inherit (self) pkgs inputs;
      };

      outputsBuilder = channels: {
        # construct packagesBuilder to export all packages defined in overlays
        packages = fromOverlays self.overlays channels;
        devShell = with channels.nixpkgs; devshell.mkShell {
          name = "devShell";
          commands = [
            {
              name = nvfetcher-bin.pname;
              help = nvfetcher-bin.meta.description;
              command = "cd $DEVSHELL_ROOT/packages; ${nvfetcher-bin}/bin/nvfetcher -c ./sources.toml --no-output $@; nixpkgs-fmt _sources";
            }
          ];
          packages = [
            nixpkgs-fmt
            (python3.withPackages (ps: with ps;[
              btest
            ]))
            zed
          ];
        };
      };

      overlay = final: prev:
        let
          nixpkgs-hardenedlinux-sources = (import ./packages/_sources/generated.nix) {
            inherit (final) fetchurl fetchgit;
          };
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
        // { inherit nixpkgs-hardenedlinux-sources; };
    };
}
