
Target hardware:
    VOLTCRAFT VC-870 Multimeter
    UNI-T UT-D04 USB Cable

The issue this software solves:
    Although the Voltcraft multimeter and the UNI-T USB cable are hardware compatible (the USB cable adapter fits
    into the multimeter connector perfectly), the software requirements are different.
    Original Voltcraft USB cable, which costs tripple the UNI-T cable by the way, mimics RS232 adapter when plugged in USB host PC.
    The UNI-T cable uses different chip internally and behaves like a HID device.
    On the other hand, UNI-T multimeters use different communication protocol over the serial line than VC870.

    This software package is composed of two independent parts:
    1. USB cable interface in the utd04-cable directory,
    2. multimeter protocol decoder in the vc870-decode directory.

    The USB cable interface is adapted from other work, see copyrights in the directory.
    Compile according to instructions in the utd04-cable/readme.2.txt file.

    The multimeter protocol decoder is a perl script. Use in a pipe together with the cable interface:

        ./utd04-cable/utd04-cable -b9600 | ./vc870-decode/vc870-decode.pl

    The above commands need to be run under root (su) because of USB access permissions required in the cable interface program.


Web page & author:
    Jaroslav Sykora
    http://www.jsykora.info

    + authors of the USB cable inteface, see readme.1.txt
