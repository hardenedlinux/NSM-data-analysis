{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn, nixpkgs-hardenedlinux-sources }:

buildGoPackage rec {
  inherit (nixpkgs-hardenedlinux-sources.zed) pname src version;

  goPackagePath = "github.com/brimdata/zed";

  goDeps = ./deps.nix;

  meta = {
    description = "Command-line processor for structured logs";
    homepage = "https://github.com/brimdata/zq";
  };
}
