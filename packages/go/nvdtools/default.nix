{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:
let

in
buildGoPackage rec {
  name = "nvdtools";

  version = builtins.substring 0 7 rev;

  rev = "127947dc6ca16a5ae4c2257566e7ea0a79d68a15";

  goPackagePath = "github.com/facebookincubator/nvdtools";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/facebookincubator/nvdtools";
    sha256 = "sha256-7KtzFD5yi+hiA1CwKe+OZ/4jGp4HYIGrbZF7A3Q5WC8=";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "A set of tools to work with the feeds (vulnerabilities, CPE dictionary etc.) distributed by National Vulnerability Database (NVD)";
    homepage = "https://github.com/GTrunSec/nvdtools";
  };
}
