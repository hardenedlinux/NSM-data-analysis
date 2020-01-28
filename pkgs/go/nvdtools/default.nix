{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "nvdtools";
  version = "master";
  rev = "fb7a240403148b3ff2baa91b7b6420b9c67a3927";

  goPackagePath = "src/nvdtools";
  src = fetchgit {
    inherit rev;
    url = "https://github.com/GTrunSec/nvdtools";
    sha256 = "04cjx01bfbia7gj1zr98w6dgshfgg7749lmk4q8mj6gnxbvjs6pz";
  };

  goDeps = ./deps.nix;

  # TODO: add metadata https://nixos.org/nixpkgs/manual/#sec-standard-meta-attributes
  meta = {
    description = "A set of tools to work with the feeds (vulnerabilities, CPE dictionary etc.) distributed by National Vulnerability Database (NVD)";
    homepage = "https://github.com/GTrunSec/nvdtools";
  };
}
