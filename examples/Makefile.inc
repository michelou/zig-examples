ifeq ($(OS),Windows_NT)
ifndef MSYS_HOME
$(error Variable MSYS_HOME is not set)
endif
ifndef ZIG_HOME
$(error Variable ZIG_HOME is not set)
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
