# Define compilation type
OSTYPE=msys
#OSTYPE=oda320
#OSTYPE=odgcw0

PRGNAME     = oswan-od

# define regarding OS, which compiler to use
ifeq "$(OSTYPE)" "msys"	
EXESUFFIX = .exe
TOOLCHAIN = /c/MinGW32
CC          = gcc
LD          = gcc
else
ifeq "$(OSTYPE)" "oda320"	
TOOLCHAIN = /opt/opendingux-toolchain/usr
else
TOOLCHAIN = /opt/gcw0-toolchain/usr
endif
EXESUFFIX = .dge
CC = $(TOOLCHAIN)/bin/mipsel-linux-gcc
LD = $(TOOLCHAIN)/bin/mipsel-linux-gcc
endif

# add SDL dependencies
SDL_LIB     = $(TOOLCHAIN)/lib
SDL_INCLUDE = $(TOOLCHAIN)/include

# change compilation / linking flag options
ifeq "$(OSTYPE)" "msys"	
F_OPTS = -fsigned-char 
CC_OPTS = -O2 $(F_OPTS)
CFLAGS      = -I$(SDL_INCLUDE) $(CC_OPTS)
CXXFLAGS=$(CFLAGS)
LDFLAGS     = -L$(SDL_LIB) -lmingw32 -lSDLmain -lSDL -mwindows 
else
F_OPTS = -falign-functions -falign-loops -falign-labels -falign-jumps \
	-ffast-math -fsingle-precision-constant -funsafe-math-optimizations \
	-fomit-frame-pointer -fno-builtin -fno-common \
	-fstrict-aliasing  -fexpensive-optimizations \
	-finline -finline-functions -fpeel-loops -fsigned-char 
ifeq "$(OSTYPE)" "oda320"	
CC_OPTS	= -O2 -mips32 -msoft-float -G0 -D_OPENDINGUX_ -D_VIDOD16_ $(F_OPTS)
else
CC_OPTS	= -O2 -mips32 -mhard-float -G0 -D_OPENDINGUX_ -D_VIDOD32_ $(F_OPTS)
endif
CFLAGS      = -I$(SDL_INCLUDE) -DOPENDINGUX $(CC_OPTS)
CXXFLAGS=$(CFLAGS) 
LDFLAGS     = -L$(SDL_LIB) $(CC_OPTS) -lSDL 
endif

# Files to be compiled
SRCDIR    = ./emu/cpu ./emu ./opendingux .
VPATH     = $(SRCDIR)
SRC_C   = $(foreach dir, $(SRCDIR), $(wildcard $(dir)/*.c))
OBJ_C   = $(notdir $(patsubst %.c, %.o, $(SRC_C)))
SRC_CP   = $(foreach dir, $(SRCDIR), $(wildcard $(dir)/*.cpp))
OBJ_CP   = $(notdir $(patsubst %.cpp, %.o, $(SRC_CP)))
OBJS     = $(OBJ_C) $(OBJ_CP)

# Rules to make executable
$(PRGNAME)$(EXESUFFIX): $(OBJS)  
ifeq "$(OSTYPE)" "msys"	
	$(LD) $(CFLAGS) -o $(PRGNAME)$(EXESUFFIX) $^ $(LDFLAGS)
else
	$(LD) $(LDFLAGS) -o $(PRGNAME)$(EXESUFFIX) $^
endif

$(OBJ_C) : %.o : %.c
	$(CC) $(CXXFLAGS) -c -o $@ $<

$(OBJ_CP) : %.o : %.cpp
	$(CC) $(CXXFLAGS) -c -o $@ $<

clean:
	rm -f $(PRGNAME)$(EXESUFFIX) *.o
