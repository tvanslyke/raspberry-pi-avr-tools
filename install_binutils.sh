tar -xf binutils-2.31.tar.xz
mkdir build-binutils
cd build-binutils
./../binutils-2.31/configure --target=avr --enable-languages=c,c++ --with-sysroot --disable-nls
make -j 4
sudo make install
cd ..
