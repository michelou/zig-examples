#!/usr/bin/env pwsh
#
# Copyright (c) 2018-2026 Stéphane Micheloud
#
# Licensed under the MIT License.
#

## https://powershellisfun.com/2023/04/24/using-the-requires-statement-in-powershell/
#Requires -Version 5.1

## only for interactive debugging !
$DEBUG = $false

#########################################################################
## Environment setup

$EXITCODE = 0

$EXE = ""
if ($PSVersionTable.PSVersion -lt "6.0" -or $IsWindows) {
  # Fix case when both the Windows and Linux builds of this program
  # are installed in the same directory.
  $EXE = '.exe'
}

$BASENAME = (Get-Item $PSScriptRoot).Basename
$ROOT_DIR = $PSScriptRoot
#$PATH_SEP = [IO.Path]::PathSeparator
$SEP      = [IO.Path]::DirectorySeparatorChar

$SOURCE_DIR      = Join-Path -Path $ROOT_DIR   -ChildPath 'src'
$TARGET_DIR      = Join-Path -Path $ROOT_DIR   -ChildPath 'target'
$TARGET_DOCS_DIR = Join-Path -Path $TARGET_DIR -ChildPath 'docs'

$ZIG_CMD = $Env:ZIG_HOME + $SEP + 'zig' + $EXE
if (! (Test-Path -PathType Leaf -Path $ZIG_CMD)) {
    Write-Error "Zig compiler not found (check variable ""ZIG_HOME"")"
    Cleanup 1
}

$PS_VERSION = $PSVersionTable.PSVersion.ToString() 
$PROJECT_NAME = $BASENAME
$PROJECT_VERSION = '1.0-SNAPSHOT'

#########################################################################
## Script arguments

$COMMANDS = @()

## Possible values: SilentlyContinue, Stop, Continue, Inquire, Ignore, Suspend
$DebugPreference   = 'SilentlyContinue'
$VerbosePreference = 'SilentlyContinue'
$WarningPreference = 'Continue'

$VERBOSE = $false
$N = 0
foreach ($ARG in $args) {
    if ($ARG.StartsWith("-")) {
        ## option
        if ($ARG -ieq '-debug') { $DEBUG = $true; $DebugPreference='Continue'
        } elseif ($ARG -ieq '-help'   ) { $COMMANDS = 'Print-Help'
        } elseif ($ARG -ieq '-verbose') { $VERBOSE = $true; $VerbosePreference = 'Continue'
        } else {
            Write-Error "Unknown option ""$ARG"""
            $EXITCODE = 1
            break
        }
    } else {
        ## subcommand
        if ($ARG -ieq 'clean') { $COMMANDS += 'Clean'
        } elseif ($ARG -ieq 'compile') { $COMMANDS += 'Compile'
        } elseif ($ARG -ieq 'doc' ) { $COMMANDS += 'Generate-Doc'
        } elseif ($ARG -ieq 'help') { $COMMANDS = 'Print-Help'
        } elseif ($ARG -ieq 'run' ) { $COMMANDS += 'Compile', 'Run'
        } else {
            Write-Error "Unknown subcommand ""$ARG"""
            $EXITCODE = 1
            break
        }
        $N++
    }
}
$TARGET = $TARGET_DIR + $SEP + $PROJECT_NAME + $EXE

Write-Debug "Properties : PROJECT_NAME=$PROJECT_NAME PROJECT_VERSION=$PROJECT_VERSION PS_VERSION=$PS_VERSION"
Write-Debug "Options    : DEBUG=$DEBUG VERBOSE=$VERBOSE"
Write-Debug "Subcommands: $COMMANDS"
Write-Debug "Variables  : ""GIT_HOME=$Env:GIT_HOME"""
Write-Debug "Variables  : ""ZIG_HOME=$Env:ZIG_HOME"""

#########################################################################
## Subroutines

function Main
{
    foreach($COMMAND in $COMMANDS) {
        &$COMMAND
        if ($EXITCODE -ne 0) { exit $EXITCODE }
    }
    if ($TIMER) {
        $DURATION = New-TimeSpan -Start $TIMER_START -End (Get-Date)
        Write-Output "Total execution time: $DURATION"
    }
    Cleanup $EXITCODE
}

function Print-Help
{
    Write-Output "Usage: $BASENAME { <option> | <subcommand> }"
    Write-Output ""
    Write-Output "   Options:"
    Write-Output "     -debug      print commands executed by this script"
    Write-Output "     -verbose    print progress messages"
    Write-Output ""
    Write-Output "   Subcommands:"
    Write-Output "     clean       delete generated files"
    Write-Output "     compile     compile Zig source files"
    Write-Output "     help        print this help message"
    Write-Output "     run         execute main program ""$MAIN_CLASS"""
}

function Clean
{
    Delete-Directory -DirPath $TARGET_DIR
    Delete-Directory -DirPath $($ROOT_DIR + $SEP + 'build')
    Delete-Directory -DirPath $($ROOT_DIR + $SEP + 'zig-out')
    Delete-Directory -DirPath $($ROOT_DIR + $SEP + '.zig-cache')
}

function Delete-Directory
{
    param (
        [string] $DirPath
    )
    if (Test-Path -PathType Container -Path $DirPath) {
        Write-Debug "[System.IO.Directory]::Delete('$DirPath', $true)"
        Write-Verbose "Delete directory ""$($DirPath.Replace($ROOT_DIR + $SEP, ''))"""
        try {
            #[System.IO.Directory]::Delete($DirPath, $true)
            Remove-Item -Path $DirPath -Force -Recurse
        } catch {
            Write-Error "Failed to delete directory ""$($DirPath.Replace($ROOT_DIR + $SEP, ''))"""
            $EXITCODE = 1
            return
        }
    }
}

function Compile
{
    if (! (Test-Path -PathType Container -Path $TARGET_DIR)) {
        $_ = New-Item -ItemType Directory -Path $TARGET_DIR
    }
    $ZIP_OPTS = @("-femit-bin=$TARGET", '-target', 'x86_64-windows')

    $SOURCE_FILES = (Get-ChildItem -Path $SOURCE_DIR -Include "*.zig" -Recurse).FullName
    $N = $SOURCE_FILES.Count
    if ($N -eq 0) {
        Write-Warning "No Zig source file found"
        return
    } elseif ($N -eq 1) { $N_FILES = "$N Zig source file"
    } else { $N_FILES = "$N Zig source files"
    }
    Write-Debug """$ZIG_CMD"" build-exe $ZIP_OPTS $SOURCE_FILES"
    Write-Verbose "Compile $N_FILES to directory ""$($TARGET_DIR.Replace($ROOT_DIR + $SEP, ''))"""
    &"$ZIG_CMD" build-exe $ZIP_OPTS $SOURCE_FILES
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to compile $N_FILES to directory ""$($TARGET_DIR.Replace($ROOT_DIR + $SEP, ''))"""
        $EXITCODE = 1
        return
    }
}

function Generate-Doc
{
    if (! (Test-Path -PathType Container -Path $TARGET_DOCS_DIR)) {
        $_ = New-Item -ItemType Directory -Path $TARGET_DOCS_DIR
    }
    $ZIP_OPTS = @("-femit-docs=$TARGET_DOCS_DIR")

    $SOURCE_FILES = (Get-ChildItem -Path $SOURCE_DIR -Include "*.zig" -Recurse).FullName
    $N = $SOURCE_FILES.Count
    if ($N -eq 0) {
        Write-Warning "No Zig source file found"
        return
    } elseif ($N -eq 1) { $N_FILES = "$N Zig source file"
    } else { $N_FILES = "$N Zig source files"
    }
    Write-Debug """$ZIG_CMD"" build-exe $ZIP_OPTS $SOURCE_FILES"
    Write-Verbose "Generate HTML documentation into directory ""$($TARGET_DIR.Replace($ROOT_DIR + $SEP, ''))"""
    &"$ZIG_CMD" build-exe $ZIP_OPTS $SOURCE_FILES
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to generate HTML documetation into directory ""$($TARGET_DOCS_DIR.Replace($ROOT_DIR + $SEP, ''))"""
        $EXITCODE = 1
        return
    }
    $INDEX_FILE = $TARGET_DOCS_DIR + $SEP + 'index.html'
    if (Test-Path -PathType Leaf -Path $INDEX_FILE) {
        Write-Output "HTML index page is ""$($INDEX_FILE.Replace($ROOT_DIR + $SEP, ''))"""
    }
}

function Run
{
    if (! (Test-Path -PathType Leaf -Path $TARGET)) {
        Write-Error "Zig executable ""$($TARGET.Replace($ROOT_DIR + $SEP, ''))"" not found"
        Cleanup 1
    }
    Write-Debug """$TARGET"""
    Write-Verbose "Execute ""$($TARGET.Replace($ROOT_DIR + $SEP, ''))"""
    &"$TARGET"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to execute ""$($TARGET.Replace($ROOT_DIR + $SEP, ''))"""
        Cleanup 1
    }
}

function Cleanup
{
    param (
        [int] $ExitCode
    )
    Write-Debug "ExitCode=$ExitCode"
    exit $ExitCode
}

#########################################################################
## Entry-point

Main
