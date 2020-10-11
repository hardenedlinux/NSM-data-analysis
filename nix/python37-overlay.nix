final: prev:
rec {
  python3 = prev.python37.override {
    packageOverrides = selfPythonPackages: pythonPackages: {
      voila = prev.python3Packages.callPackage ../pkgs/python/voila {};
    };
  };
}
