self: super:
# Within the overlay we use a recursive set, though I think we can use `self` as well.
rec {
    python3 = super.python3.override {
      packageOverrides = selfPythonPackages: pythonPackages: {
      pytorch = pythonPackages.pytorch.overridePythonAttrs (oldAttrs: {
        version = "1.3.0";
        pname = "pytorch";
        src = super.fetchFromGitHub {
          owner  = "pytorch";
          repo   = "pytorch";
          rev    = "v1.3.0";
          fetchSubmodules = true;
          sha256 = "1219m9mfadnif43bd3f64csa3qbx4za7rc0ic6yawgwmx8f6jqn0";
        };
      });
    };
  };

}
