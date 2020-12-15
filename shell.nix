{ pkgs }:
with pkgs;
let
      hardenedlinux-python-packages = (pkgs.python37.withPackages (ps: with ps;[
            beakerx
            elastalert
            btest
            fastai
            zat
            cefpython3
            pyshark
            tldextract
            yarapython
            python-pptx
            jupyterlab_git
            jupyter_lsp
            fastai
            choochoo
            # cudf ../include/rmm/detail/memory_manager.hpp:37:10: fatal error: rmm/detail/cnmem.h: No such file or directory
            # axelrod pathlib 1.0.1 does not support 3.7
      ])).override (args: { ignoreCollisions = true;});

in
mkShell {
      buildInputs = [
            hardenedlinux-python-packages
            #vast
            zeek
            deepsea
            nvdtools
            sybilhunter
            zq
      ];
}
