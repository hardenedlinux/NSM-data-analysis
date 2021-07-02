final: prev:
{
  nixpkgs-hardenedlinux-sources = prev.callPackage (import ../packages/_sources/generated.nix) { };
}
