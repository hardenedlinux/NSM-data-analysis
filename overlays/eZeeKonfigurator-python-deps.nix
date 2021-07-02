final: prev:
{
  eZeeKonfigurator-requirements = final.machlib.mkPython rec {
    #requirements = builtins.readFile (final.nixpkgs-hardenedlinux-sources.eZeeKonfigurator.src + "/requirements_common.txt") + ''
    requirements = ''
      setuptools-rust
      multidict==4.7.6
      chardet==3.0.4
      pyasn1==0.4.8
      aiohttp-sse-client==0.2.1
      channels==3.0.3
      Django==3.2.4
      django-crispy-forms==1.12.0
      django-eventstream==4.2.0
      GitPython==3.1.18
      requests==2.25.1
      gitdb2==4.0.2
      psycopg2==2.9.1
    '';
  };
}
