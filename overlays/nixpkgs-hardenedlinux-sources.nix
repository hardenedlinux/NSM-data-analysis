final: prev:
{
  nixpkgs-hardenedlinux-sources = prev.callPackage ../packages/_sources/generated.nix { };
}
