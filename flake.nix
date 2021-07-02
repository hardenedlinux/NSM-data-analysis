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
    mach-nix = { url = "github:DavHau/mach-nix"; inputs.nixpkgs.follows = "nixpkgs"; inputs.pypi-deps-db.follows = "pypi-deps-db"; };
    pypi-deps-db = {
      url = "github:DavHau/pypi-deps-db";
      flake = false;
    };
  };


  outputs = inputs: with builtins; with inputs;
    let
      inherit (utils.lib.exporters) internalOverlays fromOverlays modulesFromList;
      inherit (nixpkgs) lib;
      inherit (builtins) attrValues;
      inherit (utils-lib) pathsToImportedAttrs overlayPaths;
      utils-lib = import ./lib/utils-ext.nix { inherit lib; };
    in
    utils.lib.systemFlake {
      inherit self inputs;

      channels.nixpkgs.input = nixpkgs;
      channelsConfig = {
        allowUnsupportedSystem = true;
        allowBroken = true;
        allowUnfree = true;
      };

      sharedOverlays =
        [
          self.overlay
          nvfetcher.overlay
          (import "${devshell-flake}/overlay.nix")
          (final: prev:
            {
              __dontExport = true;
              #python
              machlib = import mach-nix {
                pkgs = prev;
                pypiDataRev = pypi-deps-db.rev;
                pypiDataSha256 = pypi-deps-db.narHash;
              };
            })
        ] ++ (attrValues (pathsToImportedAttrs overlayPaths));

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
