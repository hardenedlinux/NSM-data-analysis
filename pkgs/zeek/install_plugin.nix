{ }:
''

install_plugin(){
    name=$1
    path=$2
    version=$3
    mkdir -p /build/$1
    cp -r $2/* /build/$1/
    cd /build/$name/
    if [ $name == 'spicy' ] ; then
    ./configure --with-zeek=$out --generator=Ninja --enable-ccache
    make -j8 all && make install
    fi
    if [ $name == 'metron-bro-plugin-kafka' ] || [ $name == 'asd' ]; then
        ./configure --bro-dist=/build/zeek-$3
        make -j8 all && make install
    fi
    if [ $name == 'zeek-postgresql' ] || [ $name == 'bro-http2']; then
       ./configure --zeek-dist=/build/zeek-$3
        make -j8 all && make install
    fi

}
install_plugin $1 $2 $3

''
