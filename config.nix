 {
  packageOverrides = pkgs: {
    #julia_13 = pkgs.julia_13.overrideAttrs(oldAttrs: {checkTarget = "";});
  };
  allowUnfree = true;
  allowBroken = true; # intero only?
  permittedInsecurePackages = [
    "openssl-1.0.2u"
  ];
}
