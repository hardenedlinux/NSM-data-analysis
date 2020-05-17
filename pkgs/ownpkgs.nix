## https://github.com/NixOS/nixpkgs/issues/77503 openssl 1.0.2 is not supported
let
  src = builtins.fetchTarball {
    url    = "https://github.com/GTrunSec/nixpkgs/tarball/927fcf37933ddd24a0e16c6a45b9c0a687a40607";
    sha256 = "0yk5dvnd9s4j3y9rs2x7hh1ndgr2fy41max58cz09w5sq01lgrpw";
  };
in
import src
