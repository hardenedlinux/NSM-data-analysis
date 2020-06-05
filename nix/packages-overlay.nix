self: super:
{
  vast = super.callPackage ../pkgs/vast {};
  broker = pkgs.callPackage ../pkgs/broker {};
  zeek = pkgs.callPackage ./pkgs/zeek { };
}
