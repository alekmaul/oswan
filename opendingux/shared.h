#ifndef SHARED_H
#define SHARED_H

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <dirent.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/types.h>

#include <SDL/SDL.h>

// defines and macros
#define MAX__PATH 1024
#define FILE_LIST_ROWS 19

#define SYSVID_WIDTH	224
#define SYSVID_HEIGHT	144

#define GF_GAMEINIT    1
#define GF_MAINUI      2
#define GF_GAMEQUIT    3
#define GF_GAMERUNNING 4

#ifndef O_BINARY
#define O_BINARY 0
#endif

#define true 1
#define false 0
typedef int bool;

#define PIX_TO_RGB(fmt, r, g, b) (((r>>fmt->Rloss)<<fmt->Rshift)| ((g>>fmt->Gloss)<<fmt->Gshift)|((b>>fmt->Bloss)<<fmt->Bshift))

// osWan dependencies
#include "../emu/WS.h"
#include "../emu/WSApu.h"
#include "../emu/WSFileio.h"
#include "../emu/WSRender.h"

#define cartridge_IsLoaded() (strlen(gameName) != 0)

typedef struct {
  unsigned int sndLevel;
  unsigned int m_ScreenRatio; // 0 = original show, 1 = full screen
  unsigned int OD_Joy[12]; // each key mapping
  unsigned int m_DisplayFPS;
  char current_dir_rom[MAX__PATH];
} gamecfg;

//typedef unsigned char byte;
typedef unsigned short word;
typedef unsigned int uint;

extern SDL_Surface* screen;						// Main program screen
extern SDL_Surface* actualScreen;						// Main program screen

extern SDL_Surface *layer,*layerback,*layerbackgrey;

extern SDL_Event event;

extern gamecfg GameConf;
extern unsigned int m_Flag;

extern char gameName[512];
extern char current_conf_app[MAX__PATH];

extern unsigned int gameCRC;

extern void system_loadcfg(char *cfg_name);
extern void system_savecfg(char *cfg_name);

extern unsigned long crc32 (unsigned int crc, const unsigned char *buf, unsigned int len);

extern void mainemuinit();

// menu
extern void screen_showtopmenu(void);
extern void print_string_video(int x, int y, const char *s);

#endif
