const std = @import("std");

pub fn main(init: std.process.Init) !void {
    // See https://ziglang.org/documentation/0.16.0/#Hello-World
    try std.Io.File.stdout().writeStreamingAll(init.io, "Hello, world!\n");
}
