#!/usr/bin/env bash
#
# Copyright (c) 2018-2024 Stéphane Micheloud
#
# Licensed under the MIT License.
#

##############################################################################
## Subroutines

getHome() {
    local source="${BASH_SOURCE[0]}"
    while [[ -h "$source" ]]; do
        local linked="$(readlink "$source")"
        local dir="$( cd -P $(dirname "$source") && cd -P $(dirname "$linked") && pwd )"
        source="$dir/$(basename "$linked")"
    done
    ( cd -P "$(dirname "$source")" && pwd )
}

debug() {
    local DEBUG_LABEL="[46m[DEBUG][0m"
    [[ $DEBUG -eq 1 ]] && echo "$DEBUG_LABEL $1" 1>&2
}

warning() {
    local WARNING_LABEL="[46m[WARNING][0m"
    echo "$WARNING_LABEL $1" 1>&2
}

error() {
    local ERROR_LABEL="[91mError:[0m"
    echo "$ERROR_LABEL $1" 1>&2
}

# use variables EXITCODE, TIMER_START
cleanup() {
    [[ $1 =~ ^[0-1]$ ]] && EXITCODE=$1

    if [[ $TIMER -eq 1 ]]; then
        local TIMER_END=$(date +'%s')
        local duration=$((TIMER_END - TIMER_START))
        echo "Total execution time: $(date -d @$duration +'%H:%M:%S')" 1>&2
    fi
    debug "EXITCODE=$EXITCODE"
    exit $EXITCODE
}

args() {
    [[ $# -eq 0 ]] && HELP=1 && return 1

    for arg in "$@"; do
        case "$arg" in
        ## options
        -debug)       DEBUG=1 ;;
        -help)        HELP=1 ;;
        -verbose)     VERBOSE=1 ;;
        -*)
            error "Unknown option $arg"
            EXITCODE=1 && return 0
            ;;
        ## subcommands
        clean)   CLEAN=1 ;;
        compile) COMPILE=1 ;;
        help)    HELP=1 ;;
        run)     COMPILE=1 && RUN=1 ;;
        *)
            error "Unknown subcommand $arg"
            EXITCODE=1 && return 0
            ;;
        esac
    done
    debug "Options    : PROJECT_CONFIG=$PROJECT_CONFIG TIMER=$TIMER TOOLSET=$TOOLSET VERBOSE=$VERBOSE"
    debug "Subcommands: CLEAN=$CLEAN COMPILE=$COMPILE HELP=$HELP RUN=$RUN"
    debug "Variables  : GIT_HOME=$GIT_HOME"
    debug "Variables  : SDL2_HOME=$SDL2_HOME"
    debug "Variables  : ZIG_HOME=$ZIG_HOME"
}

help() {
    cat << EOS
Usage: $BASENAME { <option> | <subcommand> }

  Options:
    -debug       print commands executed by this script
    -verbose     print progress messages

  Subcommands:
    clean        delete generated files
    compile      compile Zig source files
    help         print this help message
    run          execute the generated executable
EOS
}

clean() {
    if [[ -d "$TARGET_DIR" ]]; then
        if [[ $DEBUG -eq 1 ]]; then
            debug "Delete directory \"$TARGET_DIR\""
        elif [[ $VERBOSE -eq 1 ]]; then
            echo "Delete directory \"${TARGET_DIR/$ROOT_DIR\//}\"" 1>&2
        fi
        rm -rf "$TARGET_DIR"
        [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )
    fi
    if [[ -d "$ROOT_DIR/.zig-cache" ]]; then
        if [[ $DEBUG -eq 1 ]]; then
            debug "Delete directory \"$ROOT_DIR/.zig-cache\""
        elif [[ $VERBOSE -eq 1 ]]; then
            echo "Delete directory \".zig-cache\"" 1>&2
        fi
        rm -rf "$ROOT_DIR/.zig-cache"
        [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )
    fi
}

compile() {
    [[ -d "$TARGET_DIR" ]] || mkdir -p "$TARGET_DIR"
    local zig_opts="-femit-bin=\"$(mixed_path $TARGET)\" -target x86_64-windows"
    ## we add the SDL2 dependency options
    zig_opts="$zig_opts -I\"$SDL2_HOME\include\" -I\"$(mixed_path $ZIG_HOME)/lib/libc/include/any-windows-any\""
    zig_opts="$zig_opts -L\"$SDL2_LIB_DIR\" -lSDL2"

    local source_files=
    local n=0
    for f in $(find "$SOURCE_DIR/" -type f -name "*.zig" 2>/dev/null); do
        source_files="$source_files \"$(mixed_path $f)\""
        n=$((n + 1))
    done
    if [[ $n -eq 0 ]]; then
        warning "No Zig source file found"
        return 1
    fi
    local s=; [[ $n -gt 1 ]] && s="s"
    local n_files="$n Zig source file$s"
    if [[ $DEBUG -eq 1 ]]; then
        debug "\"$ZIG_CMD\" $zig_opts $source_files"
    elif [[ $VERBOSE -eq 1 ]]; then
        echo "Compile $n_files to directory \"${TARGET_DIR/$ROOT_DIR\//}\"" 1>&2
    fi
    eval "\"$ZIG_CMD\" build-exe $zig_opts $source_files"
    if [[ $? -ne 0 ]]; then
        error "Failed to compile $n_files to directory \"${TARGET_DIR/$ROOT_DIR\//}\""
        cleanup 1
    fi
    if [[ $DEBUG -eq 1 ]]; then
        debug "cp \"$(mixed_path $SDL2_DLL_FILE)\" \"$TARGET_DIR\""
    elif [[ $VERBOSE -eq 1 ]]; then
        echo "Copy SDL2 dynamic library to directory \"${TARGET_DIR/$ROOT_DIR\//}\"" 1>&2
    fi
    eval "cp \"$(mixed_path $SDL2_DLL_FILE)\" \"$TARGET_DIR\""
    if [[ $? -ne 0 ]]; then
        error "Failed to copy SDL2 dynamic library to directory \"${TARGET_DIR/$ROOT_DIR\//}\""
        cleanup 1
    fi
}

mixed_path() {
    if [[ -x "$CYGPATH_CMD" ]]; then
        $CYGPATH_CMD -am "$*"
    elif [[ $mingw -eq 1 ]] || [[ $msys -eq 1 ]]; then
        echo "$*" | sed 's|/|\\\\|g'
    else
        echo "$*"
    fi
}

dump() {
    echo "dump"
}

run() {
    if [[ ! -f "$TARGET" ]]; then
        error "Executable \"${TARGET/$ROOT_DIR\//}\" not found"
        cleanup 1
    fi
    if [[ $DEBUG -eq 1 ]]; then
        debug "$TARGET"
    elif [[ $VERBOSE -eq 1 ]]; then
        echo "Execute \"${TARGET/$ROOT_DIR\//}\"" 1>&2
    fi
    eval "$TARGET"
    if [[ $? -ne 0 ]]; then
        error "Failed to execute \"${TARGET/$ROOT_DIR\//}\"" 1>&2
        cleanup 1
    fi
}

##############################################################################
## Environment setup

BASENAME=$(basename "${BASH_SOURCE[0]}")

EXITCODE=0

ROOT_DIR="$(getHome)"

SOURCE_DIR="$ROOT_DIR/src"
TARGET_DIR="$ROOT_DIR/build"

CLEAN=0
COMPILE=0
DEBUG=0
HELP=0
RUN=0
VERBOSE=0

COLOR_START="[32m"
COLOR_END="[0m"

cygwin=0
mingw=0
msys=0
darwin=0
case "$(uname -s)" in
    CYGWIN*) cygwin=1 ;;
    MINGW*)  mingw=1 ;;
    MSYS*)   msys=1 ;;
    Darwin*) darwin=1      
esac
unset CYGPATH_CMD
PSEP=":"
TARGET_EXT=
if [[ $(($cygwin || $mingw || $msys)) -gt 0 ]]; then
    CYGPATH_CMD="$(which cygpath 2>/dev/null)"
	PSEP=";"
    TARGET_EXT=".exe"
    CMAKE_CMD="$(mixed_path $CMAKE_HOME)/bin/cmake.exe"
    MAKE_CMD="$(mixed_path $MSYS_HOME)/usr/bin/make.exe"
    ZIG_CMD="$(mixed_path $ZIG_HOME)/zig.exe"
else
    CMAKE_CMD=cmake
    MAKE_CMD=make
    ZIG_CMD=zig
fi
PROJECT_NAME="$(basename $ROOT_DIR)"
TARGET="$(mixed_path $TARGET_DIR)/$PROJECT_NAME$TARGET_EXT"

case "$(arch)" in
    x86_64) arch=x64 ;;
    *)      arch=x86
esac
SDL2_LIB_DIR="$SDL2_HOME\\lib\\$arch"
if [[ ! -f "$(mixed_path $SDL2_LIB_DIR)/SDL2.dll" ]]; then
    error "SDL2 dynamic library not found"
    cleanup 1
fi
SDL2_DLL_FILE="$SDL2_LIB_DIR\SDL2.dll"

args "$@"
[[ $EXITCODE -eq 0 ]] || cleanup 1

##############################################################################
## Main

[[ $HELP -eq 1 ]] && help && cleanup

if [[ $CLEAN -eq 1 ]]; then
    clean || cleanup 1
fi
if [[ $COMPILE -eq 1 ]]; then
    compile || cleanup 1
fi
if [[ $RUN -eq 1 ]]; then
    run || cleanup 1
fi
cleanup
