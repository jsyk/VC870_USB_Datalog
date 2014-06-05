/*******************************************************
 UT61E / HOITEK HE2325U USB interface SW
 by Rainer Wetzel (c) 2011 (diyftw.de)

 Based on:
     hidtest.cpp - Windows HID simplification

     Alan Ott
     Signal 11 Software

     8/22/2009

     Copyright 2009, All Rights Reserved.
 
     This contents of this file may be used by anyone
     for any reason without any conditions and may be
     used as a starting point for your own applications
     which use HIDAPI.

 As well as on this for the decode of the raw data:
     hoitek.cpp
     by Bernd Herd (C) 2009 (herdsoft.com)

     Based on:
     tenma.c
     by Robert Kavaler (c) 2009 (relavak.com)

     Utility program to read daata from a Houtek HID UART device.
     This device is used in the USB cable for PeakTech 3315 DMM devices
     and Likely Tinma 72-7730 DMM.

     Based on linux /dev/hidraw interface.

********************************************************/

#include <stdio.h>
#include <wchar.h>
#include <string.h>
#include <stdlib.h>
#include "hidapi.h"

// Headers needed for sleeping.
#ifdef _WIN32
    #include <windows.h>
#else
    #include <unistd.h>
#endif

int main(int argc, char* argv[])
{
    int res;
    unsigned char buf[256];
    #define MAX_STR 255
    hid_device *handle=0;
    int i;
    int dev_cnt = 0;

#ifdef WIN32
    UNREFERENCED_PARAMETER(argc);
    UNREFERENCED_PARAMETER(argv);
#endif

    struct hid_device_info *devs, *cur_dev;
    int bps = -1;

    int optch;

    while ((optch = getopt(argc, argv, "b:h")) > 0) {
        switch (optch) {
            case 'b': {
                // set baud speed
                if (sscanf(optarg, "%d", &bps) != 1) {
                    fprintf(stderr, "Baud rate after -b must be a number. Given: %s\n", optarg);
                    exit(1);
                }
                break;
            }
            case 'h': {
                // print help
                printf("Usage help:\n");
                printf("  utd04-cable -b <baudrate> [<usbdevice>]\n");
                printf("    <baudrate>:  19200 for UNI-T UT61E\n");
                printf("                  9600 for VOLTCRAFT VC-870\n");
                exit(0);
            }
        }
    }
    

    if(argc == optind) // if no params are supplied list available devs
    {
        devs = hid_enumerate(0x1a86, 0xe008); // all chips this SW belongs to...
        cur_dev = devs; 
        while(cur_dev){cur_dev = cur_dev->next; dev_cnt++; }
        printf("[!] found %i devices:\n",dev_cnt);

        cur_dev = devs; 
        while (cur_dev) {
           printf("%s\n", cur_dev->path);
           cur_dev = cur_dev->next;
        }

        hid_free_enumeration(devs);
    }


    if (optind < argc) // use the supplied device (if any)
    {
        handle = hid_open_path(argv[optind]);
    }   

    // Open the device using the VID, PID,
    // and optionally the Serial number (NULL for the hoitek chip).
    if (handle==0) {
        handle = hid_open(0x1a86, 0xe008, NULL); // 1a86 e008
    }

    if (!handle) {
        fprintf(stderr, "unable to open device\n");
        return 1;
    }


/*
    // Read the Product String
    wstr[0] = 0x0000;
    res = hid_get_product_string(handle, wstr, MAX_STR);
    if (res < 0)
        printf("Unable to read product string\n");
    printf("Product String: %ls\n", wstr);
*/

    // Set the hid_read() function to be non-blocking.
//  hid_set_nonblocking(handle, 1);



    memset(buf,0x00,sizeof(buf));
    
    //unsigned int bps = 19200;
    // unsigned int bps = 9600;
    if (bps < 0) {
        fprintf(stderr, "Baudspeed not specified! Use -b <baudspeed> command line option.\n");
        exit(1);
    }
    // Send a Feature Report to the device
    buf[0] = 0x0; // report ID
    buf[1] = bps;
    buf[2] = bps>>8;
    buf[3] = bps>>16;
    buf[4] = bps>>24;
    buf[5] = 0x03; // 3 = enable?
    res = hid_send_feature_report(handle, buf, 6); // 6 bytes
    if (res < 0) {
        fprintf(stderr, "Unable to send a feature report.\n");
    }

    memset(buf,0,sizeof(buf));

    printf("-data start-\n");

    usleep(1000);

    do {

        res = 0;
        while (res == 0)
        {
            res = hid_read(handle, buf, sizeof(buf));
            if (res == 0)
                fprintf(stderr, "waiting...\n");
            if (res < 0)
                fprintf(stderr, "Unable to read()\n");
        }

        // format data 
        int len=buf[0] & 7; // the first byte contains the length in the lower 3 bits ( 111 = 7 )
        for (i=0; i<len; i++)
            buf[i+1] &= 0x7f; // bitwise and with 0111 1111, mask the upper bit which is always 1

        if(len>0)
        {
            fwrite(buf+1, 1, len, stdout); // write data directly to stdout to enable pipeing to interpreter app
            fflush(stdout);
        }


        }while(res>=0);
      //  printf("%s",hid_error(handle));
        hid_close(handle);

#ifdef WIN32
    system("pause");
#endif

    return 0;
}
