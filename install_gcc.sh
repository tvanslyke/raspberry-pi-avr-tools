tar -xf gcc-8.2.0.tar.xz
mkdir build-gcc
cd build-gcc
./../gcc-8.0.0/configure --program-prefix=avr- --program-suffix=-8 --target=avr --enable-languages=c,c++ --with-avrlibc --disable-nls  --without-headers
make -j 4 all-gcc
make -j 4 all-target-libgcc
sudo make install-gcc
sudo make install-target-libgcc
cd ..
