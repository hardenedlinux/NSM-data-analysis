{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "sybilhunter";
  version = "master";
  rev = "2f0a8f09308f7de51ce1095353f4af82a8a15f88";

  goPackagePath = "src/sybilhunter";
  src = fetchgit {
    inherit rev;
    url = "https://github.com/NullHypothesis/sybilhunter";
    sha256 = "1gbvnalv98g366k2d0ziirqyi5psic3ga48qjdhyaslc1dns50xw";
  };

  goDeps = ./deps.nix;

  # TODO: add metadata https://nixos.org/nixpkgs/manual/#sec-standard-meta-attributes
  meta = {
    description = "Hunting for Sybils and anomalies in archived Tor network data";
    homepage = "https://github.com/NullHypothesis/sybilhunter";
  };
}
