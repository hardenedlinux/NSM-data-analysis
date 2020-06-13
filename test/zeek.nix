let
  overlays = [
    (import ../nix/packages-overlay.nix)
  ];

  pkgs = (import ../nix/nixpkgs.nix ) { inherit overlays;};
in
{
  Env-zeek = pkgs.buildEnv {
    name = "nsm-zeek";
    paths = with pkgs; [
      (zeek.override{ KafkaPlugin = true; PostgresqlPlugin = true; Http2Plugin = true;})
    ];
  };
}
