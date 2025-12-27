const std = @import("std");

pub fn main() !void {
    //const stdout = std.io.getStdOut().writer();
    //try stdout.print("Hello, {s}!\n", .{"world"});
    try std.fs.File.stdout().writeAll("Hello, world!\n");
}
