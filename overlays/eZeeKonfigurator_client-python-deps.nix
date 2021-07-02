final: prev:
{
  eZeeKonfigurator_client-requirements = final.machlib.mkPython rec {
    requirements = builtins.readFile (final.nixpkgs-hardenedlinux-sources.eZeeKonfigurator_client.src + "/brokerd/requirements.txt") + ''

    '';
  };
}
