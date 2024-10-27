# <span id="top">Playing with Zig on Windows</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;"><a href="https://ziglang.org/" rel="external"><img src="docs/images/zig-logo.svg" width="100" alt="Rust project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://ziglang.org/" rel="external">Zig</a> code examples coming from various websites and books.<br/>
  It also includes several build scripts (<a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting">batch files</a>, <a href="https://makefiletutorial.com/" rel="external">Make scripts</a>) for experimenting with <a href="https://ziglang.org/" rel="external">Zig</a> on a Windows machine.</td>
  </tr>
</table>

[Ada][ada_examples], [Akka][akka_examples], [C++][cpp_examples], [COBOL][cobol_examples], [Dafny][dafny_examples], [Dart][dart_examples], [Deno][deno_examples], [Docker][docker_examples], [Flix][flix_examples], [Golang][golang_examples], [GraalVM][graalvm_examples], [Haskell][haskell_examples], [Kafka][kafka_examples], [Kotlin][kotlin_examples], [LLVM][llvm_examples], [Modula-2][m2_examples], [Node.js][nodejs_examples], [Rust][rust_examples], [Scala 3][scala3_examples], [Spark][spark_examples], [Spring][spring_examples], [TruffleSqueak][trufflesqueak_examples] and [WiX Toolset][wix_examples] are other topics we are continuously monitoring.

## <span id="proj_deps">Project dependencies</span>

This project depends on two external software for the **Microsoft Windows** platform:

- [Git 2.47][git_downloads] ([*release notes*][git_relnotes])
- [Zig 0.13][zig_downloads] ([*release notes*][zig_relnotes])

Optionally one may also install the following software:

- [ConEmu 2023][conemu_downloads] ([*release notes*][conemu_relnotes])
- [SDL 2][sdl_downloads] ([*release notes*][sdl2_relnotes])
- [SDL 3][sdl_downloads] ([*release notes*][sdl3_relnotes])
- [Visual Studio Code 1.94][vscode_downloads] ([*release notes*][vscode_relnotes])
- [Zig 0.14 DEV][zig_downloads]

> **:mag_right:** Git for Windows provides a BASH emulation used to run [**`git`**][git_docs] from the command line (as well as over 250 Unix commands like [**`awk`**][man1_awk], [**`diff`**][man1_diff], [**`file`**][man1_file], [**`grep`**][man1_grep], [**`more`**][man1_more], [**`mv`**][man1_mv], [**`rmdir`**][man1_rmdir], [**`sed`**][man1_sed] and [**`wc`**][man1_wc]).

For instance our development environment looks as follows (*October 2024*) <sup id="anchor_01">[1](#footnote_01)</sup>:

<pre style="font-size:80%;">
C:\opt\ConEmu\           <i>( 26 MB)</i>
C:\opt\Git\              <i>(367 MB)</i>
C:\opt\SDL2\             <i>( 21 MB)</i>
C:\opt\SDL3\             <i>( 49 MB)</i>
C:\opt\zig-0.13.0\       <i>(293 MB)</i>
C:\opt\zig-0.14.0-dev\   <i>(269 MB)</i>
C:\opt\VSCode\           <i>(371 MB)</i>
</pre>

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive][zip_archive] rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*similar to* the [**`/opt/`**][linux_opt] directory on Unix).

## <span id="structure">Directory structure</span> [**&#x25B4;**](#top)

This project is organized as follows:
<pre style="font-size:80%;">
bin\*.bat
docs\
examples\{<a href="examples/README.md">README.md</a>, <a href="./examples/hello/">hello</a>}
sdl-examples\{<a href="sdl-examples/README.md">README.md</a>, <a href="./dsl-examples/hello-gavedev/">hello-gamedev</a>, <a href="./dsl-examples/hello-gavedev-dsl3/">hello-gamedev-sdl3</a>}
README.md
<a href="RESOURCES.md">RESOURCES.md</a>
<a href="setenv.bat">setenv.bat</a>
</pre>

where

- directory [**`bin\`**](bin/) provides several utility [batch files][windows_batch_file].
- directory [**`docs\`**](docs/) contains [Zig][zig_lang] related papers/articles.
- directory [**`examples\`**](examples/) contains [Zig][zig_lang] code examples (see [**`README.md`**](./examples/README.md)).
- file **`README.md`** is the [Markdown][github_markdown] document for this page.
- file [**`RESOURCES.md`**](RESOURCES.md) is the [Markdown][github_markdown] document presenting external resources.
- file [**`setenv.bat`**](setenv.bat) is the batch script for setting up our environment.

We also define a virtual drive &ndash; e.g. drive **`H:`** &ndash; in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"][windows_limitation] from Microsoft Support).

> **:mag_right:** We use the Windows external command [**`subst`**][windows_subst] to create virtual drives; for instance:
>
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst">subst</a> H: <a href="https://en.wikipedia.org/wiki/Environment_variable#Default_values">%USERPROFILE%</a>\workspace\zig-examples</b>
> </pre>

In the next section we give a brief description of the batch files present in this project.

## <span id="batch_commands">Batch commands</span> [**&#x25B4;**](#top)

### **`setenv.bat`**

We execute command [**`setenv.bat`**](setenv.bat) once to setup our development environment:

<pre style="font-size:80%;">
<b>&gt; <a href="setenv.bat">setenv</a></b>
Tool versions:
   zig 0.13.0, make 3.81, SDL2 2.30.8.0, SDL3 3.1.3.0,
   git 2.47.0, diff 3.10, bash 5.2.37(1)
</pre>

## <span id="usage_examples">Usage examples</span> [**&#x25B4;**](#top)

### **`setenv.bat`**

Command [**`setenv.bat`**](setenv.bat) with option **`-verbose`** displays additional information:
- the tool paths (which may not contain the version suffix, i.e. **`C:\opt\Git\bin\git.exe`** in some installations),
- the environment variables *defined locally* within this session,
- and the path associations (i.e. **`H:\`** in this case, but other drive names may be displayed as path associations are *globally defined*).

<pre style="font-size:80%;">
<b>&gt; <a href="setenv.bat">setenv</a> -verbose</b>
Tool versions:
   zig 0.13.0, make 3.81, SDL2 2.30.8.0, SDL3 3.1.3.0,
   git 2.47.0, diff 3.10, bash 5.2.37(1)
Tool paths:
   C:\opt\zig-0.13.0\zig.exe
   C:\opt\make-3.81\bin\make.exe
   C:\opt\Git\bin\git.exe
   C:\opt\Git\usr\bin\diff.exe
   C:\opt\Git\bin\bash.exe
Environment variables:
   "GIT_HOME=C:\opt\Git"
   "MAKE_HOME=C:\opt\make-3.81"
   "MSYS_HOME=C:\opt\msys64"
   "SDL2_HOME=C:\opt\sdl2"
   "SDL3_HOME=C:\opt\sdl3"
   "ZIG_HOME=C:\opt\zig-0.13.0"
Path associations:
   H:\: => %USERPROFILE%\workspace-perso\zig-examples
</pre>

<!--=======================================================================-->

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> ***Downloads*** [↩](#anchor_01)

<dl><dd>
In our case we downloaded the following installation files (see <a href="#proj_deps">section 1</a>):
</dd>
<dd>
<pre style="font-size:80%;">
<a href="https://github.com/Maximus5/ConEmu/releases/tag/v23.07.24" rel="external">ConEmuPack.230724.7z</a>                              <i>(  5 MB)</i>
<a href="https://git-scm.com/download/win" rel="external">PortableGit-2.47.0-64-bit.7z.exe</a>                  <i>( 41 MB)</i>
<a href="https://github.com/libsdl-org/SDL/releases" rel="external">SDL2-devel-2.30.8-VC.zip </a>                         <i>(  6 MB)</i>
<a href="https://github.com/libsdl-org/SDL/releases/tag/preview-3.1.3" rel="external">SDL3-devel-3.1.3-VC.zip </a>                          <i>( 13 MB)</i>
<a href="https://code.visualstudio.com/Download#" rel="external">VSCode-win32-x64-1.94.2.zip</a>                       <i>(131 MB)</i>
<a href="https://ziglang.org/download/" rel="external">zig-windows-x86_64-0.13.0.zip</a>                     <i>( 75 MB)</i>
<a href="">zig-windows-x86_64-0.14.0-dev.2051+b1361f237.zip</a>  <i>( 80 MB)</i>
</pre>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/October 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[ada_examples]: https://github.com/michelou/ada-examples#top
[akka_examples]: https://github.com/michelou/akka-examples#top
[cobol_examples]: https://github.com/michelou/cobol-examples#top
[conemu_downloads]: https://github.com/Maximus5/ConEmu/releases
[conemu_relnotes]: https://conemu.github.io/blog/2023/07/24/Build-230724.html
[cpp_examples]: https://github.com/michelou/cpp-examples#top
[dafny_examples]: https://github.com/michelou/dafny-examples#top
[dart_examples]: https://github.com/michelou/dart-examples#top
[deno_examples]: https://github.com/michelou/deno-examples#top
[docker_examples]: https://github.com/michelou/docker-examples#top
[flix_examples]: https://github.com/michelou/flix-examples#top
[git_docs]: https://git-scm.com/docs/git
[git_downloads]: https://git-scm.com/download/win
[github_markdown]: https://github.github.com/gfm/
[git_relnotes]: https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.45.2.txt
[golang_examples]: https://github.com/michelou/golang-examples#top
[graalvm_examples]: https://github.com/michelou/graalvm-examples#top
[haskell_examples]: https://github.com/michelou/haskell-examples#top
[kafka_examples]: https://github.com/michelou/kafka-examples#top
[kotlin_examples]: https://github.com/michelou/kotlin-examples#top
[linux_opt]: https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html
[llvm_examples]: https://github.com/michelou/llvm-examples#top
[m2_examples]: https://github.com/michelou/m2-examples#top
[man1_awk]: https://www.linux.org/docs/man1/awk.html
[man1_diff]: https://www.linux.org/docs/man1/diff.html
[man1_file]: https://www.linux.org/docs/man1/file.html
[man1_grep]: https://www.linux.org/docs/man1/grep.html
[man1_more]: https://www.linux.org/docs/man1/more.html
[man1_mv]: https://www.linux.org/docs/man1/mv.html
[man1_rmdir]: https://www.linux.org/docs/man1/rmdir.html
[man1_sed]: https://www.linux.org/docs/man1/sed.html
[man1_wc]: https://www.linux.org/docs/man1/wc.html
[nodejs_examples]: https://github.com/michelou/nodejs-examples#top
[rust_examples]: https://github.com/michelou/rust-examples#top
[sdl_downloads]: https://www.libsdl.org/
[sdl2_relnotes]: https://github.com/libsdl-org/SDL/releases/tag/release-2.30.8
[sdl3_relnotes]: https://github.com/libsdl-org/SDL/releases/tag/release-3.1.3
[scala3_examples]: https://github.com/michelou/dotty-examples#top
[spark_examples]: https://github.com/michelou/spark-examples#top
[spring_examples]: https://github.com/michelou/spring-examples#top
[trufflesqueak_examples]: https://github.com/michelou/trufflesqueak-examples#top
[vscode_downloads]: https://code.visualstudio.com/#alt-downloads
[vscode_relnotes]: https://code.visualstudio.com/updates/
[windows_batch_file]: https://en.wikibooks.org/wiki/Windows_Batch_Scripting
[windows_limitation]: https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation
[windows_subst]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst
[wix_examples]: https://github.com/michelou/wix-examples#top
[zig_downloads]: https://ziglang.org/download/
[zig_lang]: https://ziglang.org/
[zig_relnotes]: https://ziglang.org/download/0.13.0/release-notes.html
[zip_archive]: https://www.howtogeek.com/178146/
