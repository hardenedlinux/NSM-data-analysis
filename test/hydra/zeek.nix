let
  overlays = [
    (import ../../nix/packages-overlay.nix)
  ];

  pkgs = (import <nixpkgs>) { inherit overlays;};
in
{
  hardenedlinux-zeek = pkgs.buildEnv {
    name = "nsm-zeek";
    paths = with pkgs; [
      (zeek.override{ KafkaPlugin = true; PostgresqlPlugin = true; Http2Plugin = true;})
    ];
  };
}
