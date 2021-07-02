{ lib, ... }:
let
  inherit (builtins) attrNames isAttrs readDir listToAttrs;

  inherit (lib) removeSuffix;

  genAttrs' = values: f: listToAttrs (map f values);

  pathsToImportedAttrs = paths:
    genAttrs' paths (path: {
      name = removeSuffix ".nix" (baseNameOf path);
      value = import path;
    });
in
{
  inherit genAttrs' pathsToImportedAttrs;

  overlayPaths =
    let
      overlayDir = ../overlays;
      fullPath = name: overlayDir + "/${name}";
    in
    map fullPath (attrNames (readDir overlayDir));
}
