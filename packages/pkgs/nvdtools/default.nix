{ stdenv
, buildGoPackage
, nixpkgs-hardenedlinux-sources
}:
let

in
buildGoPackage rec {
  inherit (nixpkgs-hardenedlinux-sources.nvdtools) pname version src;

  goPackagePath = "github.com/facebookincubator/nvdtools";

  goDeps = ./deps.nix;

  meta = {
    description = "A set of tools to work with the feeds (vulnerabilities, CPE dictionary etc.) distributed by National Vulnerability Database (NVD)";
    homepage = "https://github.com/GTrunSec/nvdtools";
  };
}
