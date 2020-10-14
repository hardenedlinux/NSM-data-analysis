let
  overlays = [
    (import ../../nix/packages-overlay.nix)
  ];

  pkgs = (import <nixpkgs>) { inherit overlays;};
  #nixpkgs = (import ~/.config/nixpkgs/nixos/channel/nixpkgs) { };
  zeekWithSpicy = (pkgs.zeek.override{ KafkaPlugin = true; PostgresqlPlugin = true; Http2Plugin = true; SpicyPlugin = true;});
in
{
  hardenedlinux-zeek = pkgs.buildEnv {
    name = "nsm-zeek";
    paths = with pkgs; [
      (zeek.override{ KafkaPlugin = true; PostgresqlPlugin = true; Http2Plugin = true;
                      CommunityIdPlugin = true; Ikev2Plugin = true; PdfPlugin = true;
                    })
    ];
  };
}
