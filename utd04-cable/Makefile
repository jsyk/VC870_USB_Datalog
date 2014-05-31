###########################################
# he2325u interface program
#
# Rainer Wetzel
# 2011-02-18
###########################################

OUT=utd04-cable

all: $(OUT)

CC=gcc
CXX=g++
COBJS=./hidapi/linux/hid.o
CPPOBJS=./he2325u.o
OBJS=$(COBJS) $(CPPOBJS)
CFLAGS+=-I./hidapi/hidapi -Wall -g -c `pkg-config libusb-1.0 --cflags`
LIBS=`pkg-config libusb-1.0 libudev --libs`


$(OUT): $(OBJS)
	g++ -Wall -g $^ $(LIBS) -o $(OUT)

$(COBJS): %.o: %.c
	$(CC) $(CFLAGS) $< -o $@

$(CPPOBJS): %.o: %.cpp
	$(CXX) $(CFLAGS) $< -o $@

clean:
	rm -f $(OBJS) $(OUT)

.PHONY: clean
