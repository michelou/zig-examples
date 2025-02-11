@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging
set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

if %_HELP%==1 (
    call :help
    exit /b !_EXITCODE!
)

set _GIT_PATH=
set _MAKE_PATH=
set _MSYS_PATH=
set _ZIG_PATH=

call :cmake
if not %_EXITCODE%==0 goto end

@rem we use %MSYS_HOME%\usr\bin\make.exe instead.
@rem call :make
@rem if not %_EXITCODE%==0 goto end

call :msys
if not %_EXITCODE%==0 goto end

call :sdl2
if not %_EXITCODE%==0 goto end

call :sdl3
if not %_EXITCODE%==0 (
    echo %_WARNING_LABEL% SDL 3 library not installed 1>&2
    set _EXITCODE=0
)
call :zig
if not %_EXITCODE%==0 goto end

call :git
if not %_EXITCODE%==0 goto end

goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:
goto :eof

:env_colors
@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd

@rem normal foreground colors
set _NORMAL_FG_BLACK=[30m
set _NORMAL_FG_RED=[31m
set _NORMAL_FG_GREEN=[32m
set _NORMAL_FG_YELLOW=[33m
set _NORMAL_FG_BLUE=[34m
set _NORMAL_FG_MAGENTA=[35m
set _NORMAL_FG_CYAN=[36m
set _NORMAL_FG_WHITE=[37m

@rem normal background colors
set _NORMAL_BG_BLACK=[40m
set _NORMAL_BG_RED=[41m
set _NORMAL_BG_GREEN=[42m
set _NORMAL_BG_YELLOW=[43m
set _NORMAL_BG_BLUE=[44m
set _NORMAL_BG_MAGENTA=[45m
set _NORMAL_BG_CYAN=[46m
set _NORMAL_BG_WHITE=[47m

@rem strong foreground colors
set _STRONG_FG_BLACK=[90m
set _STRONG_FG_RED=[91m
set _STRONG_FG_GREEN=[92m
set _STRONG_FG_YELLOW=[93m
set _STRONG_FG_BLUE=[94m
set _STRONG_FG_MAGENTA=[95m
set _STRONG_FG_CYAN=[96m
set _STRONG_FG_WHITE=[97m

@rem strong background colors
set _STRONG_BG_BLACK=[100m
set _STRONG_BG_RED=[101m
set _STRONG_BG_GREEN=[102m
set _STRONG_BG_YELLOW=[103m
set _STRONG_BG_BLUE=[104m

@rem we define _RESET in last position to avoid crazy console output with type command
set _BOLD=[1m
set _UNDERSCORE=[4m
set _INVERSE=[7m
set _RESET=[0m
goto :eof

@rem input parameter: %*
@rem output parameters: _BASH, _HELP, _VERBOSE
:args
set _BASH=0
set _HELP=0
set _VERBOSE=0
:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-bash" ( set _BASH=1
    ) else if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="help" ( set _HELP=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
    )
)
shift
goto args_loop
:args_done
call :drive_name "%_ROOT_DIR%"
if not %_EXITCODE%==0 goto :eof
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _BASH=%_BASH% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _HELP=%_HELP% 1>&2
    echo %_DEBUG_LABEL% Variables  : _DRIVE_NAME=%_DRIVE_NAME% 1>&2
)
goto :eof

@rem input parameter: %1: path to be substituted
@rem output parameter: _DRIVE_NAME (2 characters: letter + ':')
:drive_name
set "__GIVEN_PATH=%~1"
@rem remove trailing path separator if present
if "%__GIVEN_PATH:~-1,1%"=="\" set "__GIVEN_PATH=%__GIVEN_PATH:~0,-1%"

@rem https://serverfault.com/questions/62578/how-to-get-a-list-of-drive-letters-on-a-system-through-a-windows-shell-bat-cmd
set __DRIVE_NAMES=F:G:H:I:J:K:L:M:N:O:P:Q:R:S:T:U:V:W:X:Y:Z:
for /f %%i in ('wmic logicaldisk get deviceid ^| findstr :') do (
    set "__DRIVE_NAMES=!__DRIVE_NAMES:%%i=!"
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% __DRIVE_NAMES=%__DRIVE_NAMES% ^(WMIC^) 1>&2
if not defined __DRIVE_NAMES (
    echo %_ERROR_LABEL% No more free drive name 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f "tokens=1,2,*" %%f in ('subst') do (
    set "__SUBST_DRIVE=%%f"
    set "__SUBST_DRIVE=!__SUBST_DRIVE:~0,2!"
    set "__SUBST_PATH=%%h"
    @rem Windows local file systems are not case sensitive (by default)
    if /i "!__SUBST_DRiVE!"=="!__GIVEN_PATH:~0,2!" (
        set _DRIVE_NAME=!__SUBST_DRIVE:~0,2!
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        ) else if %_VERBOSE%==1 ( echo Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        )
        goto :eof
    ) else if "!__SUBST_PATH!"=="!__GIVEN_PATH!" (
        set "_DRIVE_NAME=!__SUBST_DRIVE!"
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        ) else if %_VERBOSE%==1 ( echo Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        )
        goto :eof
    )
)
for /f "tokens=1,2,*" %%i in ('subst') do (
    set __USED=%%i
    call :drive_names "!__USED:~0,2!"
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% __DRIVE_NAMES=%__DRIVE_NAMES% ^(SUBST^) 1>&2

set "_DRIVE_NAME=!__DRIVE_NAMES:~0,2!"
if /i "%_DRIVE_NAME%"=="%__GIVEN_PATH:~0,2%" goto :eof

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% subst "%_DRIVE_NAME%" "%__GIVEN_PATH%" 1>&2
) else if %_VERBOSE%==1 ( echo Assign drive %_DRIVE_NAME% to path "!__GIVEN_PATH:%USERPROFILE%=%%USERPROFILE%%!" 1>&2
)
subst "%_DRIVE_NAME%" "%__GIVEN_PATH%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to assign drive %_DRIVE_NAME% to path "!__GIVEN_PATH:%USERPROFILE%=%%USERPROFILE%%!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem input parameter: %1=Used drive name
@rem output parameter: __DRIVE_NAMES
:drive_names
set "__USED_NAME=%~1"
set "__DRIVE_NAMES=!__DRIVE_NAMES:%__USED_NAME%=!"
goto :eof

:help
if %_VERBOSE%==1 (
    set __BEG_P=%_STRONG_FG_CYAN%
    set __BEG_O=%_STRONG_FG_GREEN%
    set __END=%_RESET%
) else (
    set __BEG_P=
    set __BEG_O=
    set __END=
)
echo Usage: %__BEG_O%%_BASENAME% { ^<option^> ^| ^<subcommand^> }%__END%
echo.
echo   %__BEG_P%Options:%__END%
echo     %__BEG_O%-bash%__END%       start Git bash shell instead of Windows command prompt
echo     %__BEG_O%-debug%__END%      print commands executed by this script
echo     %__BEG_O%-verbose%__END%    print progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%help%__END%        print this help message
goto :eof

@rem output parameter: _CMAKE_HOME
:cmake
set _CMAKE_HOME=
@rem set _CMAKE_PATH=

set __CMAKE_CMD=
for /f "delims=" %%f in ('where cmake.exe 2^>NUL') do set "__CMAKE_CMD=%%f"
if defined __CMAKE_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of CMake executable found in PATH 1>&2
    for /f "delims=" %%i in ("%__CMAKE_CMD%") do set "__CMAKE_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__CMAKE_BIN_DIR!.") do set "_CMAKE_HOME=%%~dpf"
    @rem keep _CMAKE_PATH undefined since executable already in path
    goto :eof
) else if defined CMAKE_HOME (
    set "_CMAKE_HOME=%CMAKE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable CMAKE_HOME 1>&2
) else (
    set "__PATH=%ProgramFiles%"
    for /f "delims=" %%f in ('dir /ad /b "!__PATH!\cmake*" 2^>NUL') do set "_CMAKE_HOME=!__PATH!\%%f"
    if not defined _CMAKE_HOME (
        set __PATH=C:\opt
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\cmake*" 2^>NUL') do set "_CMAKE_HOME=!__PATH!\%%f"
    )
)
if not exist "%_CMAKE_HOME%\bin\cmake.exe" (
    echo %_ERROR_LABEL% cmake executable not found ^("%_CMAKE_HOME%"^) 1>&2
    set _CMAKE_HOME=
    set _EXITCODE=1
    goto :eof
)
@rem set "_CMAKE_PATH=;%_CMAKE_HOME%\bin"
goto :eof

@rem output parameters: _MAKE_HOME, _MAKE_PATH
:make
set _MAKE_HOME=
set _MAKE_PATH=

set __MAKE_CMD=
for /f "delims=" %%f in ('where make.exe 2^>NUL') do set "__MAKE_CMD=%%f"
if defined __MAKE_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Make executable found in PATH 1>&2
    rem keep _MAKE_PATH undefined since executable already in path
    goto :eof
) else if defined MAKE_HOME (
    set "_MAKE_HOME=%MAKE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MAKE_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f "delims=" %%f in ('dir /ad /b "!_PATH!\make-3*" 2^>NUL') do set "_MAKE_HOME=!_PATH!\%%f"
    if defined _MAKE_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Make installation directory "!_MAKE_HOME!" 1>&2
    )
)
if not exist "%_MAKE_HOME%\bin\make.exe" (
    echo %_ERROR_LABEL% Make executable not found ^("%_MAKE_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MAKE_PATH=;%_MAKE_HOME%\bin"
goto :eof

@rem output parameter: _MSYS_HOME, _MSYS_PATH
:msys
set _MSYS_HOME=
set _MSYS_PATH=

set __GCC_CMD=
for /f "delims=" %%f in ('where gcc.exe 2^>NUL') do set "__GCC_CMD=%%f"
if defined __GCC_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of GNU Make executable found in PATH 1>&2
    for /f "delims=" %%i in ("%__GCC_CMD%") do set "__MAKE_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__MAKE_BIN_DIR!") do set "_MSYS_HOME=%%~dpf"
    @rem keep _MSYS_PATH undefined since executable already in path
    goto :eof
) else if defined MSYS_HOME (
    set "_MSYS_HOME=%MSYS_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MSYS_HOME 1>&2
) else (
    set "__PATH=%ProgramFiles%"
    for /f "delims=" %%f in ('dir /ad /b "!__PATH!\msys*" 2^>NUL') do set "_MSYS_HOME=!__PATH!\%%f"
    if not defined _MSYS_HOME (
        set __PATH=C:\opt
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\msys*" 2^>NUL') do set "_MSYS_HOME=!__PATH!\%%f"
    )
)
if not exist "%_MSYS_HOME%\usr\bin\gcc.exe" (
    echo %_ERROR_LABEL% GNU C++ executable not found ^("%_MSYS_HOME%"^) 1>&2
    set _MSYS_HOME=
    set _EXITCODE=1
    goto :eof
)
set "_MSYS_PATH=;%_MSYS_HOME%\usr\bin"
goto :eof

@rem output_parameter: _SDL2_HOME
:sdl2
set _SDL2_HOME=
if defined SDL2_HOME (
    set "_SDL2_HOME=%SDL2_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable SDL2_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\sdl2\" ( set "_SDL2_HOME=!__PATH!\sdl2"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\sdl2*" 2^>NUL') do set "_SDL2_HOME=!__PATH!\%%f"
        if not defined _SDL2_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\sdl2*" 2^>NUL') do set "_SDL2_HOME=!__PATH!\%%f"
        )
    )
    if defined _SDL2_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default SDL2 installation directory "!_SDL2_HOME!" 1>&2
    )
)
if not exist "%_SDL2_HOME%\lib\x64\SDL2.dll" (
    echo %_WARNING_LABEL% SDL2 dynamic library not found ^("%_SDL2_HOME%"^) 1>&2
    @rem set _EXITCODE=1
    set _SDL2_HOME=
    goto :eof
)
goto :eof


@rem output_parameter: _SDL3_HOME
:sdl3
set _SDL3_HOME=
if defined SDL3_HOME (
    set "_SDL3_HOME=%SDL3_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable SDL3_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\sdl3\" ( set "_SDL3_HOME=!__PATH!\sdl3"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\sdl3*" 2^>NUL') do set "_SDL3_HOME=!__PATH!\%%f"
        if not defined _SDL3_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\sdl3*" 2^>NUL') do set "_SDL3_HOME=!__PATH!\%%f"
        )
    )
    if defined _SDL3_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default SDL3 installation directory "!_SDL3_HOME!" 1>&2
    )
)
if not exist "%_SDL3_HOME%\lib\x64\SDL3.dll" (
    echo %_WARNING_LABEL% SDL3 dynamic library not found ^("%_SDL3_HOME%"^) 1>&2
    @rem set _EXITCODE=1
    set _SDL3_HOME=
    goto :eof
)
goto :eof

@rem output parameters: _ZIG_HOME
:zig
set _ZIG_HOME=

set __ZIG_CMD=
for /f "delims=" %%f in ('where zig.exe 2^>NUL') do set "__ZIG_CMD=%%f"
if defined __ZIG_CMD (
    for /f "delims=" %%i in ("%__ZIG_CMD%") do set "_ZIG_HOME=%%~dpi"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Zig executable found in PATH 1>&2
    goto :eof
) else if defined ZIG_HOME (
    set "_ZIG_HOME=%ZIG_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable ZIG_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\zig\" ( set "_ZIG_HOME=!__PATH!\zig"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\zig*" 2^>NUL') do set "_ZIG_HOME=!__PATH!\%%f"
        if not defined _ZIG_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\zig*" 2^>NUL') do set "_ZIG_HOME=!__PATH!\%%f"
        )
    )
    if defined _ZIG_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Git installation directory "!_ZIG_HOME!" 1>&2
    )
)
if not exist "%_ZIG_HOME%\zig.exe" (
    echo %_ERROR_LABEL% Cargo executable not found ^("%_ZIG_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_ZIG_PATH=;%_ZIG_HOME%"
goto :eof

@rem output parameters: _GIT_HOME, _GIT_PATH
:git
set _GIT_HOME=
set _GIT_PATH=

set __GIT_CMD=
for /f "delims=" %%f in ('where git.exe 2^>NUL') do set "__GIT_CMD=%%f"
if defined __GIT_CMD (
    for /f "delims=" %%i in ("%__GIT_CMD%") do set "__GIT_BIN_DIR=%%~dpi"
    for /f "delims=" %%f in ("!__GIT_BIN_DIR!\.") do set "_GIT_HOME=%%~dpf"
    @rem Executable git.exe is present both in bin\ and \mingw64\bin\
    if not "!_GIT_HOME:mingw=!"=="!_GIT_HOME!" (
        for /f "delims=" %%f in ("!_GIT_HOME!\.") do set "_GIT_HOME=%%~dpf"
    )
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Git executable found in PATH 1>&2
    @rem keep _GIT_PATH undefined since executable already in path
    goto :eof
) else if defined GIT_HOME (
    set "_GIT_HOME=%GIT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable GIT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\Git\" ( set "_GIT_HOME=!__PATH!\Git"
    ) else (
        for /f "delims=" %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        if not defined _GIT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f "delims=" %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        )
    )
    if defined _GIT_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Git installation directory "!_GIT_HOME!" 1>&2
    )
)
if not exist "%_GIT_HOME%\bin\git.exe" (
    echo %_ERROR_LABEL% Git executable not found ^("%_GIT_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_GIT_PATH=;%_GIT_HOME%\bin;%_GIT_HOME%\mingw64\bin;%_GIT_HOME%\usr\bin"
goto :eof

:print_env
set __VERBOSE=%1
set "__VERSIONS_LINE1=  "
set "__VERSIONS_LINE2=  "
set __WHERE_ARGS=
where /q "%ZIG_HOME%:zig.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=*" %%i in ('"%ZIG_HOME%\zig.exe" version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% zig %%i,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%ZIG_HOME%:zig.exe"
)
where /q "%MSYS_HOME%\usr\bin:make.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('"%MSYS_HOME%\usr\bin\make.exe" --version 2^>^&1 ^| findstr Make') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% make %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%MSYS_HOME%\usr\bin:make.exe"
)
where /q "%CMAKE_HOME%\bin:cmake.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('"%CMAKE_HOME%\bin\cmake.exe" --version ^| findstr version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% cmake %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%CMAKE_HOME%\bin:cmake.exe"
)
where /q "%SDL2_HOME%\lib\x64:SDL2.dll"
if %ERRORLEVEL%==0 if exist "%_ROOT_DIR%bin\pelook.exe" (
    for /f "tokens=1,2,3,*" %%i in ('call "%_ROOT_DIR%bin\pelook.exe" -h "%SDL2_HOME%\lib\x64\SDL2.dll" ^| findstr version') do (
        set "__VERSIONS_LINE1=%__VERSIONS_LINE1% SDL2 %%k,"
    )
)
where /q "%SDL3_HOME%\lib\x64:SDL3.dll"
if %ERRORLEVEL%==0 if exist "%_ROOT_DIR%bin\pelook.exe" (
    for /f "tokens=1,2,3,*" %%i in ('call "%_ROOT_DIR%bin\pelook.exe" -h "%SDL3_HOME%\lib\x64\SDL3.dll" ^| findstr version') do (
        set "__VERSIONS_LINE1=%__VERSIONS_LINE1% SDL3 %%k,"
    )
)
where /q "%GIT_HOME%\bin:git.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('"%GIT_HOME%\bin\git.exe" --version') do (
        for /f "delims=. tokens=1,2,3,*" %%a in ("%%k") do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% git %%a.%%b.%%c,"
    )
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\bin:git.exe"
)
where /q "%GIT_HOME%\usr\bin:diff.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-3,4,*" %%i in ('"%GIT_HOME%\usr\bin\diff.exe" --version ^| findstr diff') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% diff %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\usr\bin:diff.exe"
)
where /q "%GIT_HOME%\bin:bash.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-3,4,5,*" %%i in ('"%GIT_HOME%\bin\bash.exe" --version ^| findstr bash') do (
        set "__VERSION=%%l"
        setlocal enabledelayedexpansion
        set "__VERSIONS_LINE2=%__VERSIONS_LINE2% bash !__VERSION:-release=!"
    )
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\bin:bash.exe"
)
echo Tool versions:
echo %__VERSIONS_LINE1%
echo %__VERSIONS_LINE2%
if %__VERBOSE%==1 (
    echo Tool paths: 1>&2
    for /f "tokens=*" %%p in ('where %__WHERE_ARGS%') do (
        set "__LINE=%%p"
        setlocal enabledelayedexpansion
        echo    !__LINE:%USERPROFILE%=%%USERPROFILE%%! 1>&2
    )
    echo Environment variables: 1>&2
    if defined CMAKE_HOME echo    "CMAKE_HOME=%CMAKE_HOME%" 1>&2
    if defined GIT_HOME echo    "GIT_HOME=%GIT_HOME%" 1>&2
    @rem if defined MAKE_HOME echo    "MAKE_HOME=%MAKE_HOME%" 1>&2
    if defined MSYS_HOME echo    "MSYS_HOME=%MSYS_HOME%" 1>&2
    if defined SDL2_HOME echo    "SDL2_HOME=%SDL2_HOME%" 1>&2
    if defined SDL3_HOME echo    "SDL3_HOME=%SDL3_HOME%" 1>&2
    if defined ZIG_HOME echo    "ZIG_HOME=%ZIG_HOME%" 1>&2
    echo Path associations: 1>&2
    for /f "delims=" %%i in ('subst') do (
        set "__LINE=%%i"
        setlocal enabledelayedexpansion
        echo    !__LINE:%USERPROFILE%=%%USERPROFILE%%! 1>&2
    )
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
endlocal & (
    if %_EXITCODE%==0 (
        if not defined CMAKE_HOME set "CMAKE_HOME=%_CMAKE_HOME%"
        if not defined GIT_HOME set "GIT_HOME=%_GIT_HOME%"
        @rem if not defined MAKE_HOME set "MAKE_HOME=%_MAKE_HOME%"
        if not defined MSYS_HOME set "MSYS_HOME=%_MSYS_HOME%"
        if not defined SDL2_HOME set "SDL2_HOME=%_SDL2_HOME%"
        if not defined SDL3_HOME set "SDL3_HOME=%_SDL3_HOME%"
        if not defined ZIG_HOME set "ZIG_HOME=%_ZIG_HOME%"
        @rem We prepend %_GIT_HOME%\bin to hide C:\Windows\System32\bash.exe
        set "PATH=%GIT_HOME%\bin;%PATH%%_MSYS_PATH%%_GIT_PATH%%_ZIG_PATH%;%~dp0bin"
        call :print_env %_VERBOSE%
        if not "%CD:~0,2%"=="%_DRIVE_NAME%" (
            if %_DEBUG%==1 echo %_DEBUG_LABEL% cd /d %_DRIVE_NAME% 1>&2
            cd /d %_DRIVE_NAME%
        )
        if %_BASH%==1 (
            @rem see https://conemu.github.io/en/GitForWindows.html
            if %_DEBUG%==1 echo %_DEBUG_LABEL% %_GIT_HOME%\bin\bash.exe --login 1>&2
            cmd.exe /c "%_GIT_HOME%\bin\bash.exe --login"
        )
    )
    if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)
