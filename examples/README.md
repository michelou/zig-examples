# <span id="top">Zig examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;"><a href="https://ziglang.org/"><img style="border:0;" src="../docs/images/zig-logo.svg" width="100" alt="Zig project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">Directory <strong><code>examples\</code></strong> contains <a href="https://ziglang.org//" alt="Spring">Spring</a> code examples coming from various websites - mostly from the <a href="https://ziglang.org/" rel="external">Zig</a> project.
  </td>
  </tr>
</table>

## <span id="hello">`hello` Example</span>

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

***

*[mics](https://lampwww.epfl.ch/~michelou/)/June 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[pelook]: https://www.majorgeeks.com/files/details/pelook.html
