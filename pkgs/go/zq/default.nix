{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "zq";
  version = "master";
  rev = "eecf298795eed6b5fd9e64d37036655767377872";

  goPackagePath = "github.com/brimsec/zq";
  src = fetchgit {
    inherit rev;
    url = "https://github.com/brimsec/zq";
    sha256 = "0ryk2bbxd4glss1pyk8m072ams1gv6pgjjnwf87mx9glgwyq08r4";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "Command-line processor for structured logs";
    homepage = "https://github.com/brimsec/zq";
  };
}
