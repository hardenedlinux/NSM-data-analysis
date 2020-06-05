self: super:
{
  vast = super.callPackage ../pkgs/vast {};
  broker = super.callPackage ../pkgs/broker {};
  zeek = super.callPackage ../pkgs/zeek { };
}
