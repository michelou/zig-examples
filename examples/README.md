# <span id="top">Zig examples</span> <span style="font-size:90%;">[⬆](../README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;"><a href="https://ziglang.org/"><img style="border:0;" src="../docs/images/zig-logo.svg" width="100" alt="Zig project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">Directory <strong><code>examples\</code></strong> contains <a href="https://ziglang.org//" alt="Zig">Zig</a> code examples coming from various websites - mostly from the <a href="https://ziglang.org/" rel="external">Zig</a> project.
  </td>
  </tr>
</table>

## <span id="hello">`hello` Example</span>

This project has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /f /a . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./hello/build.bat">build.bat</a>
|   <a href="./hello/build.sh">build.sh</a>
|   <a href="./hello/build.zig">build.zig</a>
|   <a href="./hello/Makefile">Makefile</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>zig</b>
                <a href="./hello/src/main/zig/hello.zig">hello.zig</a>
</pre>

Command [**`zig`**](https://)`build` reads the project file [`build.zig`](./hello/build.zig) to generate the Zig program `zig-out\bin\hello.exe` :

<pre style="font-size:80%;">
<b>&gt; <a href="">zig</a> build & zig-out\bin\hello.exe</b>
Hello, world!
</pre>

Command [**`build.bat`**](./hello/build.bat)`run` generates and executes the Zig program `target\hello.exe` :

<pre style="font-size:80%;">
<b>&gt; <a href="./hello/build.bat">build</a> -verbose run</b>
Compile 1 Zig source file to directory "target"
Execute Zig program "target\hello.exe"
Hello, world!
</pre>

<pre style="font-size:80%;">
<b>&gt; <a href="">make</a> run</b>
"C:/opt/zig-0.13.0/zig.exe" build-exe -femit-bin="target/hello.exe" src/main/zig/hello.zig
target/hello.exe
Hello, world!
</pre>

<!--=======================================================================-->

## <span id="closures">`closures` Example</span> [**&#x25B4;**](#top)

This project has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
|   <a href="./closures/00download.txt">00download.txt</a>
|   <a href="./closures/build.bat">build.bat</a>
|   <a href="./closures/build.sh">build.sh</a>
|   <a href="./closures/build.zig">build.zig</a>
|   <a href="./closures/Makefile">Makefile</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>zig</b>
                <a href="./closures/src/main/zig/main.zig">main.zig</a>
</pre>

Command [**`build.bat`**](./closures/build.bat)`run` generates and executes the Zig program `target\closures.exe` :

<pre style="font-size:80%;">
<b>&gt; <a href="./closures/build.bat">build</a> -verbose run</b>
Compile 1 Zig source file to directory "target"
Execute Zig program "target\closures.exe"
Successful Operation: b.val= 11
</pre>

<!--=======================================================================-->

## <span id="pointers">`pointers` Example</span>

This project has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
|   <a href="./pointers/00download.txt">00download.txt</a>
|   <a href="./pointers/build.bat">build.bat</a>
|   <a href="./pointers/build.sh">build.sh</a>
|   <a href="./pointers/build.zig">build.zig</a>
|   <a href="./pointers/Makefile">Makefile</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>zig</b>
                <a href="./pointers/src/main/zig/main.zig">main.zig</a>
</pre>

Command [**`build.bat`**](./pointers/build.bat)`run` generates and executes the Zig program `target\pointers.exe` :

<pre style="font-size:80%;">
<b>&gt; <a href="./pointers/build.bat">build</a> -verbose run</b>
Compile 1 Zig source file to directory "target"
Execute Zig program "target\pointers.exe"
User 1 has power of 101
</pre>

<!--=======================================================================-->

## <span id="recursiveStructures">`recursiveStructures` Example</span>

This project has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="">tree</a> /a /f . | <a href="">findstr</a> /v /b [A-Z]</b>
|   <a href="./recursiveStructures/00download.txt">00download.txt</a>
|   <a href="./recursiveStructures/build.bat">build.bat</a>
|   <a href="./recursiveStructures/build.sh">build.sh</a>
|   <a href="./recursiveStructures/build.zig">build.zig</a>
|   <a href="./recursiveStructures/Makefile">Makefile</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>zig</b>
                <a href="./recursiveStructures/src/main/zig/main.zig">main.zig</a>
</pre>

Command [**`build.bat`**](./recursiveStructures/build.bat)`run` generates and executes the Zig program `target\recursiveStructures.exe` :

<pre style="font-size:80%;">
<b>&gt; <a href="./recursiveStructures/build.bat">build</a> -verbose run</b>
Compile 1 Zig source file to directory "target"
Execute Zig program "target\recursiveStructures.exe"
main.User{ .id = 1, .power = 9001, .manager = null }
main.User{ .id = 1, .power = 9001, .manager = main.User{ .id = 1, .power = 9001, .manager = null } }
</pre>

<!--=======================================================================-->

## <span id="timestamp">`timestamp` Example</span>

This project has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="">tree /a /f . | <a href="">findstr</a> /v /b [A-Z]</b>
|   <a href="./timestamp/00download.txt">00download.txt</a>
|   <a href="./timestamp/build.bat">build.bat</a>
|   <a href="./timestamp/build.sh">build.sh</a>
|   <a href="./timestamp/build.zig">build.zig</a>
|   <a href="./timestamp/Makefile">Makefile</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>zig</b>
                <a href="./timestamp/src/main/zig/main.zig">main.zig</a>
</pre>

Command [**`build.bat`**](./timestamp/build.bat)`run` generates and executes the Zig program `target\timestamp.exe` :

<pre style="font-size:80%;">
<b>&gt; <a href="./timestamp/build.bat">build</a> -verbose run</b>
Compile 1 Zig source file to directory "target"
Execute Zig program "target\timestamp.exe"
ts1=51
ts2=30
</pre>

<!--=======================================================================-->

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> **pelook** [↩](#anchor_01)

<dl><dd>
We can display internal information of the generated executable `hello.exe` with the command line tool <a href="https://www.majorgeeks.com/files/details/pelook.html" rel="external"><code>pelook</code></a> :
<pre style="font-size:80%;">
<b>&gt; <a href="https://www.majorgeeks.com/files/details/pelook.html">pelook</a> target\hello.exe | <a href="https://man7.org/linux/man-pages/man1/head.1.html">head</a> -7</b>
loaded "target\hello.exe" / 637952 (0x9BC00) bytes
signature/type:       PE64 EXE image for amd64
image checksum:       0x00000000 (calc=0x000AB346)
machine:              0x8664 (amd64)
subsystem:            3 (Windows Console)
minimum os:           6.0 (Vista)
linkver:              14.0
</pre>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/March 2025* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[pelook]: https://www.majorgeeks.com/files/details/pelook.html
