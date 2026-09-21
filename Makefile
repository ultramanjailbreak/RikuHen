```makefile
LIBPS4  := $(PS4SDK)/libPS4

CC      := gcc
OBJCOPY := objcopy

ODIR    := build
SDIR    := source
TARGET  := RikuHen.bin
MAPFILE := RikuHen.map

IDIRS   := -I$(LIBPS4)/include -Iinclude
LDIRS   := -L$(LIBPS4)

CFLAGS  := $(IDIRS) \
           -Os \
           -std=c11 \
           -ffunction-sections \
           -fdata-sections \
           -fno-builtin \
           -nostartfiles \
           -nostdlib \
           -Wall \
           -Wextra \
           -masm=intel \
           -march=btver2 \
           -mtune=btver2 \
           -m64 \
           -mabi=sysv \
           -mcmodel=small \
           -fpie \
           -fPIC

LFLAGS  := $(LDIRS) \
           -Xlinker -T \
           -Xlinker $(LIBPS4)/linker.x \
           -Xlinker -Map=$(MAPFILE) \
           -Wl,--build-id=none \
           -Wl,--gc-sections

CFILES  := $(wildcard $(SDIR)/*.c)
SFILES  := $(wildcard $(SDIR)/*.s)

OBJS := \
    $(patsubst $(SDIR)/%.c,$(ODIR)/%.o,$(CFILES)) \
    $(patsubst $(SDIR)/%.s,$(ODIR)/%.o,$(SFILES))

LIBS := -lPS4

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(ODIR) $(OBJS)
	$(CC) $(LIBPS4)/crt0.s $(OBJS) -o temp.t $(CFLAGS) $(LFLAGS) $(LIBS)
	$(OBJCOPY) -O binary temp.t $@
	rm -f temp.t
	@echo "======================================"
	@echo "Built payload: $@"
	@ls -lh "$@"
	@file "$@" || true
	@echo "======================================"

$(ODIR)/%.o: $(SDIR)/%.c
	@mkdir -p $(ODIR)
	$(CC) -c -o $@ $< $(CFLAGS)

$(ODIR)/%.o: $(SDIR)/%.s
	@mkdir -p $(ODIR)
	$(CC) -c -o $@ $< $(CFLAGS)

$(ODIR):
	mkdir -p $@

clean:
	rm -rf "$(ODIR)" "$(TARGET)" "$(MAPFILE)" temp.t
```
