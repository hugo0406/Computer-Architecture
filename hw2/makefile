.PHONY: clean

include ../../mk/toolchain.mk

CFLAGS = -march=rv32i_zicsr_zifencei -mabi=ilp32 -Ofast -Wall 

OBJS = \
    getcycles.o \
    getinstret.o \
    main.o\
    func.o

BIN = main.elf

%.o: %.s
	$(CROSS_COMPILE)gcc $(CFLAGS) -c -o $@ $<

%.o: %.c
	$(CROSS_COMPILE)gcc $(CFLAGS) -c -o $@ $<

all: $(BIN)

$(BIN): $(OBJS)
	 $(CROSS_COMPILE)gcc -o $@ $^

clean:
	$(RM) $(BIN) $(OBJS)
