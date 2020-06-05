## https://github.com/NixOS/nixpkgs/issues/77503 openssl 1.0.2 is not supported
let
  src = builtins.fetchTarball {
    url    = "https://github.com/GTrunSec/nixpkgs/tarball/fde7ed20222a3a3661d80d0a81dcae2de067baa7";
    sha256 = "1b3dgc6dwh9fk05fngwszib2zbil7nkbn4kmf2nxn76dc8dvhr3f";
  };
in
import src
