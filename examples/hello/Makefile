##
## Copyright (c) 2018-2024 Stéphane Micheloud
##
## Licensed under the MIT License.
##
##############################################################################

include ../Makefile.inc

PROJECT_NAME ?= $(shell basename $(CURDIR))

SOURCE_DIR = src
TARGET_DIR = target
TARGET_DOCS_DIR = $(TARGET_DIR)/docs

##############################################################################
## main rules

SOURCES = $(wildcard $(SOURCE_DIR)/main/zig/*.zig)
TARGET  = $(TARGET_DIR)/$(PROJECT_NAME)$(TARGET_EXT)

all: build run

build: $(TARGET)

$(TARGET): $(SOURCES)
	@$(TEST) -d "$(TARGET_DIR)" || "$(MKDIR)" -p "$(TARGET_DIR)"
	"$(ZIG)" build-exe -femit-bin="$@" $^

clean:
	"$(RM)" -rf "$(TARGET_DIR)"

run: build
	$(TARGET)

help:
	@$(ECHO) "Usage: make all|build|clean|help|run"
	@$(ECHO) ""
	@$(ECHO) "   Subcommands:"
	@$(ECHO) "     all    alias for build"
	@$(ECHO) "     build  compile Zig source files"
	@$(ECHO) "     clean  delete generated files"
	@$(ECHO) "     help   display this help message"
	@$(ECHO) "     run    execute main program \"$(TARGET)\""

##############################################################################
## doc

TARGET_DOCS = $(TARGET_DOCS_DIR)/.latest-build

doc: $(TARGET_DOCS)

$(TARGET_DOCS): $(SOURCES)
	@$(TEST) -d "$(TARGET_DOCS_DIR)" || "$(MKDIR)" -p "$(TARGET_DOCS_DIR)"
	"$(ZIG)" test -femit-docs="$(TARGET_DOCS_DIR)" $^

##############################################################################
## phony

.PHONY: all build clean doc help run

.SUFFIXES:
.SUFFIXES: .exe .html .obj .zig
