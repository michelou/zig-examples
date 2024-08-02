# <span id="top">Zig examples</span> <span style="font-size:90%;">[⬆](../README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;"><a href="https://ziglang.org/"><img style="border:0;" src="../docs/images/zig-logo.svg" width="100" alt="Zig project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">Directory <strong><code>examples\</code></strong> contains <a href="https://ziglang.org//" alt="Spring">Spring</a> code examples coming from various websites - mostly from the <a href="https://ziglang.org/" rel="external">Zig</a> project.
  </td>
  </tr>
</table>

## <span id="hello">`hello` Example</span>

This project has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /f /a . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./hello/build.bat">build.bat</a>
|   <a href="./hello/build.sh">build.sh</a>
|   <a href="./hello/Makefile">Makefile</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>zig</b>
                <a href="./hello/src/main/zig/hello.zig">hello.zig</a>
</pre>

Command [**`build.bat run`**](./hello/build.bat) generates and runs executable `hello.exe` :

<pre style="font-size:80%;">
<b>&gt; <a href="./hello/build.bat">build</a> -verbose run</b>
Compile 1 Zig source file to directory "target"
Execute Zig program "hello"
Hello, world!
</pre>

<pre style="font-size:80%;">
<b>&gt; <a href="">make</a> run</b>
"C:/opt/zig-0.13.0/zig.exe" build-exe -femit-bin="target/hello.exe" src/main/zig/hello.zig
target/hello.exe
Hello, world!
</pre>

> **Note**: We can display internal information of the generated executable `hello.exe` with the command line tool [`pelook`][pelook] :
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://www.majorgeeks.com/files/details/pelook.html">pelook</a> target\hello.exe | <a href="https://man7.org/linux/man-pages/man1/head.1.html">head</a> -7</b>
> loaded "target\hello.exe" / 637952 (0x9BC00) bytes
> signature/type:       PE64 EXE image for amd64
> image checksum:       0x00000000 (calc=0x000AB346)
> machine:              0x8664 (amd64)
> subsystem:            3 (Windows Console)
> minimum os:           6.0 (Vista)
> linkver:              14.0
> </pre>

<!--=======================================================================-->

## <span id="hello-gamedev">`hello-gamedev` Example</span> [**&#x25B4;**](#top)

This project has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /f /a . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="exernal">findstr</a> /v /b [A-Z]</b>
|   <a href="./hello-gamedev/00download.txt">00download.txt</a>
|   <a href="./hello-gamedev/build.bat">build.bat</a>
|   <a href="./hello-gamedev/build.zig">build.zig</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>zig</b>
                <a href="./hello-gamedev/src/main/zig/main.zig">main.zig</a>
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/August 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[pelook]: https://www.majorgeeks.com/files/details/pelook.html
