final: prev:
{
  #vast = prev.callPackage ../pkgs/vast {};
  #broker = prev.callPackage ../pkgs/broker {};
  zeek = prev.callPackage ../pkgs/zeek/nix { };
  spicy = prev.callPackage ../pkgs/spicy { stdenv = prev.llvmPackages_9.stdenv; };
  libclx = prev.callPackage ../pkgs/pkgs-lib/libclx { };
  librmm = prev.callPackage ../pkgs/pkgs-lib/librmm { };
  cnmem = prev.callPackage ../pkgs/pkgs-lib/cnmem { };
  deepsea = prev.callPackage ../pkgs/go/deepsea { };
  nvdtools = prev.callPackage ../pkgs/go/nvdtools { };
  sybilhunter = prev.callPackage ../pkgs/go/sybilhunter { };
  zq = prev.callPackage ../pkgs/go/zq { };
}
