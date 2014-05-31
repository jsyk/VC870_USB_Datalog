UNI-T UT61E Multimeter Software
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(C) 2011 Rainer Wetzel (diyftw.de)

This SW consists of 3 parts:

[1] "he2325u" - usb cable
        the cable is built around an Hoitek he2325u chip,
        the SW and install instructions for this chip can
        be found in the he2325u subdirectory.

        This SW outputs the (unfiltered) raw data directly.


[2] "es51922" - multimeter
        The multimeter is built around the Cyrustek ES51922 chip.
        This SW prints the data in human and machine readable csv format.

[3] "plot_es51922" - gnuplot visualizer


This SW is based on the work of the following persons (thanks!):

    Steffen Vogel: ( http://steffenvogel.de/ )
      UT61E class, main part of the interpreter (slightly modified)

    Henrik Haftmann ( http://www-user.tu-chemnitz.de/~heha/bastelecke/Rund%20um%20den%20PC/hid-ser.htm )
      he2325u.dll, Windows he2325u driver

    Bernd Herd ( http://herdsoft.com )
      hoitek.cpp, broken because of kernel changes (ubuntu 10.10 and higher) in the hidraw code

    Robert Kavaler ( relavak.com )
      tenma.c, base of hoitek.cpp
    
    Alan Ott ( http://www.signal11.us/oss/hidapi/ )
      hidapi, used by the usb cable SW


Licence:
~~~~~~~~

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.



