ifeq ($(OS),Windows_NT)
ifndef MSYS_HOME
$(error Variable MSYS_HOME is not set)
endif
ifndef ZIG_HOME
$(error Variable ZIG_HOME is not set)
endif
ifndef SDL3_HOME
$(error Variable SDL3_HOME is not set)
endif

TARGET_EXT  = .exe
PSEP        = ;
## $(MSYS_HOME)\usr\bin\{cp.exe, make.exe, wget.exe}
CP          = /usr/bin/cp.exe
ECHO        = /usr/bin/echo.exe
FIND        = /usr/bin/find.exe
MKDIR       = /usr/bin/mkdir.exe
RM          = /usr/bin/rm.exe
TEST        = /usr/bin/test.exe
TOUCH       = /usr/bin/touch.exe
#
ZIG         = $(subst \,/,$(ZIG_HOME))/zig.exe
#
SDL_LIB_NAME = SDL3
SDL_INC_DIR  = $(subst \,/,$(SDL3_HOME))/include
SDL_LIB_DIR  = $(subst \,/,$(SDL3_HOME))/lib/x64
SDL_LIB_FILE = $(SDL_LIB_DIR)/$(SDL_LIB_NAME).dll
else
TARGET_EXT  =
PSEP        = :
CP          = cp
ECHO        = echo
FIND        = find
MKDIR       = mkdir
RM          = rm
TEST        = test
TOUCH       = touch
#
ZIG         = zig
endif
