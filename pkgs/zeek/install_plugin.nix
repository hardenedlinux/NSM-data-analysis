{ llvmPackages_9 }:
''

install_plugin(){
    name=$1
    path=$2
    version=$3
    mkdir -p /build/$1
    cp -r $2/* /build/$1/
    cd /build/$name/
    if [ $name == 'spicy' ] ; then
    mkdir -p /.ccache/tmp
    ./configure --with-zeek=$out --prefix=$out --build-type=Release --enable-ccache --with-cxx-compiler=${llvmPackages_9.clang}/bin/clang++ --with-c-compiler=${llvmPackages_9.clang}/bin/clang
    make -j$(NIX_BUILD_CORES) && make install
    fi
    if [ $name == 'metron-bro-plugin-kafka' ] || [ $name == 'asd' ]; then
        ./configure --bro-dist=/build/zeek-$3
         make -j$(NIX_BUILD_CORES) && make install
    fi
    if [ $name == 'zeek-postgresql' ] || [ $name == 'bro-http2' ]; then
       ./configure --zeek-dist=/build/zeek-$3
        make -j$(NIX_BUILD_CORES) && make install
    fi

}
install_plugin $1 $2 $3

''
