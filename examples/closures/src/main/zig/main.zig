const std = @import("std");

fn Maybe(comptime T: type) type {
    return struct {
        val: ?T,
        pub fn apply(self: Maybe(T), x: anytype) Maybe(T) {
            return Maybe(T){ .val = if (self.val != null) x.fun(self.val.?) else null };
        }
        pub fn unwrapOr(self: anytype, default: T) T {
            return if (self.val != null) self.val.? else default;
        }
        pub fn init(val: T) @This() {
            return Maybe(T){ .val = val };
        }
    };
}

const Foo = struct {
    x: i32,
    pub fn fun(self: Foo, y: i32) i32 {
        return self.x + y;
    }
};

pub fn Bar(y: i32) Foo {
    return Foo{ .x = y };
}

pub fn main() !void {
    const a = Maybe(i32).init(1);
    //this will succeed and print 11
    const b = a.apply(Bar(10));
    std.debug.print("Successful Operation: b.val= {d}\n", .{b.val.?});
}
