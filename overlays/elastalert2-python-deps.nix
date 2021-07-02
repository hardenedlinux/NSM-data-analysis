final: prev:
{
  elastalert2-requirements = final.machlib.mkPython rec {
    requirements = builtins.readFile (final.nixpkgs-hardenedlinux-sources.elastalert2.src + "/requirements.txt");
  };
}
