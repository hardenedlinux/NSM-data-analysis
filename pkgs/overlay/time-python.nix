self: super:
# Within the overlay we use a recursive set, though I think we can use `self` as well.
rec {
    python3 = super.python3.override {
      packageOverrides = selfPythonPackages: pythonPackages: {
      pip = pythonPackages.pip.overridePythonAttrs (oldAttrs: {
        src = super.fetchFromGitHub {
          owner = "pypa";
          repo = "pip";
          rev = "10.0.0";
          sha256 = "0iqkpkgwfayq72z8fq0wjyjf5kh4my8skb6caj72yjb1svwvnxim";
          name = "pip-9.0.3-source";
        };
      });
    };
  };
}
