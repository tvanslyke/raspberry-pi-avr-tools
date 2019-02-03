# Arduino Development Environment
These scripts can be use to install the necessary tools for cross-platform AVR development on the Raspberry Pi.  

## `install.sh`
This script installs `avrdude`, `arduino`, `avr-gcc-8.2`, `avr-binutils-2.31`, and `avr-libc-2.0.0`.  `avr-gcc-8.2`, `avr-binutils-2.31`, and `avr-libc-2.0.0` are compiled from source and will take a fairly long time to build.  `avr-gcc-8.2` in particular will take the longest.  You'll need to your `sudo` password at several points during the process.

This script only needs to be run once.

## `new_project.sh`
After all the necessary tools have been installed with `install.sh`, the `new_project.sh` script can be used to set up a new makefile Arduino.

Example:
```sh
$ mkdir my-new-project
$ cd my-new-project
$ /<path>/<to>/new_project.sh
Cloning into './src/ArduinoSTL'...
remote: Enumerating objects: 3263, done.
remote: Total 3263 (delta 0), reused 0 (delta 0), pack-reused 3263
Receiving objects: 100% (3263/3263), 852.19 KiB | 332.00 KiB/s, done.
Resolving deltas: 100% (2453/2453), done.
$ ls
arduino  Makefile  release  src
$ 
```
### `src/`
The `src/` directory contains a minimal `main.cpp`, a `Makefile`, and an `ArduinoSTL/` directory that allows using the C++ STL.  This directory is where new source files can be added.  Be sure to update the `Makefile` when you add new files to `src/`!

### `arduino/`
The `arduino/` directory contains the source code and headers for `libarduino` along with a `Makefile` that builds the library.  The contents of this directory should only be changed if you're using an arduino board with a non-standard pin layout.

### `release/`
The `release/` directory contains the build artifacts for the project.

### `Makefile`
The included `Makefile` can be used to build and upload the source code.  Invoking `make` will build the project and `make install` will flash the program to the Arduino.
