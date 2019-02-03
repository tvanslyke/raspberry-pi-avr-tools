# Usage: Create a directory for the new arduino project and invoke this script in the directory
cp -r /usr/share/arduino/hardware/arduino/cores/arduino ./arduino
mkdir src
mkdir release

echo "HDRS = Arduino.h binary.h Client.h HardwareSerial.h IPAddress.h new.h pins_arduino.h Platform.h Printable.h Print.h \
	Server.h Stream.h Udp.h USBAPI.h USBCore.h USBDesc.h WCharacter.h wiring_private.h WString.h

OBJS = WInterrupts.o wiring_analog.o wiring.o wiring_digital.o wiring_pulse.o wiring_shift.o CDC.o HardwareSerial.o \
	HID.o IPAddress.o new.o Print.o Stream.o Tone.o USBCore.o WMath.o WString.o

#may need to adjust -mmcu if you have an older atmega168
#may also need to adjust F_CPU if your clock isn't set to 16Mhz
CFLAGS = -I./ -std=gnu99  -DF_CPU=16000000UL -Os -mmcu=atmega328p
CPPFLAGS = -I./ -DF_CPU=16000000UL -Os -mmcu=atmega328p

CC=avr-gcc-8
CPP=avr-g++-8
AR=avr-ar


default: libarduino.a

libarduino.a:   \${OBJS}
	\${AR} crs libarduino.a \$(OBJS)

.c.o: \${HDRS}
	\${CC} \${CFLAGS} -c \$*.c

.cpp.o: \${HDRS}
	\${CPP} \${CPPFLAGS} -c \$*.cpp

clean:
	rm -f \${OBJS} core a.out errs

install: libarduino.a
	mkdir -p \${PREFIX}/lib
	mkdir -p \${PREFIX}/include
	cp *.h \${PREFIX}/include
	cp *.a \${PREFIX}/lib
" > arduino/Makefile
cp /usr/share/arduino/hardware/arduino/variants/standard/pins_arduino.h ./arduino/

echo "release/firmware.hex: release/firmware.elf
	avr-objcopy -O ihex -R .eeprom release/firmware.elf release/firmware.hex

build_firmware:
	cd src/ && \$(MAKE)

src/firmware.elf: build_firmware

release/firmware.elf: src/firmware.elf
	cp src/firmware.elf release/firmware.elf

arduino/libarduino.a: ./arduino/*.h ./arduino/*.cpp ./arduino/*.c
	cd arduino/ && \$(MAKE)

install: release/firmware.elf
	avrdude -v -D -patmega328p -carduino -b57600 -C/usr/share/arduino/hardware/tools/avrdude.conf -P/dev/ttyUSB0 -Uflash:w:release/firmware.hex:i

serial:
	# picocom --echo --omap=crlf --baud=115200 /dev/ttyUSB0
	python3 serialcomm.py

clean:
	cd src/ && \$(MAKE) clean
	rm release/firmware.elf
	rm release/firmware.hex
" > ./Makefile

git clone https://github.com/mike-matera/ArduinoSTL.git ./src/ArduinoSTL

echo "CC=avr-gcc-8
CXX=avr-g++-8
AR=avr-ar

DEVICE=__AVR_ATmega328P__

CXXFLAGS=-mmcu=atmega328p -std=c++17 -O2 -fmax-errors=5 -Wall -Wextra -DF_CPU=16000000L -DARDUINO=105 -ffunction-sections -fdata-sections -w -I./../arduino/ -I./ArduinoSTL/src

OBJECTS=main.o

firmware.elf: \$(OBJECTS) ./../arduino/libarduino.a
	\$(CXX) \$(OBJECTS) ./../arduino/libarduino.a \$(CXXFLAGS) -o firmware.elf

main.o: main.cpp
	\$(CXX) main.cpp -c \$(CXXFLAGS) 

./../arduino/libarduino.a:
	cd ./../arduino && \$(MAKE)

clean:
	rm ./*.o
	rm firmware.elf
" > src/Makefile

mv arduino/main.cpp src/main.cpp
