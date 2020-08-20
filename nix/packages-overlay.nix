self: super:
{
  vast = super.callPackage ../pkgs/vast {};
  broker = super.callPackage ../pkgs/broker {};
  zeek = super.callPackage ../pkgs/zeek { };
  spicy = super.callPackage ../pkgs/spicy { stdenv = super.llvmPackages_9.stdenv; };
  libclx = super.callPackage ../pkgs/pkgs-lib/libclx {};
  librmm = super.callPackage ../pkgs/pkgs-lib/librmm {};
}
