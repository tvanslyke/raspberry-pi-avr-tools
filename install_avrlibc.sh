tar -xf avr-libc-2.0.0.tar.xz
mkdir build-avrlibc
cd build-avrlibc
./../avr-libc-2.0.0/configure --build=`./config.guess` --host=avr
make -j 4
sudo make install