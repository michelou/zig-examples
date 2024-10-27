const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "hello-gamedev",
        .root_source_file = .{ .path = "src/main/zig/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const sdl_path = "C:\\opt\\SDL3\\";
    exe.addIncludePath(sdl_path ++ "include");
    exe.addLibraryPath(sdl_path ++ "lib\\x64");
    b.installBinFile(sdl_path ++ "lib\\x64\\SDL2.dll", "SDL3.dll");
    exe.linkSystemLibrary("sdl3");
    exe.linkLibC();
    exe.install();
}
