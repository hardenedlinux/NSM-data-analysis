{ python3, pkgs }:
let
  my-overlay = pkgs.fetchFromGitHub {
    owner = "hardenedlinux";
    repo = "NSM-data-analysis";
    rev = "576e588e3b1e4f2738f4b7e2ca55c59e8be7d689";
    sha256 = "118h2hi5ib9rfbk3kclvi273zf4zqw1igxxi846amj8096wkcfbv";
  };
in
python3.override {
  packageOverrides = self: super: rec {
    editdistance =  self.callPackage "${my-overlay}/pkgs/python/editdistance" {};
    voila =  self.callPackage "${my-overlay}/pkgs/python/voila" {};
  };
}
