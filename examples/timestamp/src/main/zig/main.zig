const std = @import("std");

	const DateTime = struct {
		year: u16,
		month: u8,
		day: u8,
		hour: u8,
		minute: u8,
		second: u8,
	};

pub fn main() void {
	const ts1 = Timestamp{.unix = 1693278411};
	std.debug.print("ts1={d}\n", .{ts1.seconds()});

    const ts2 = Timestamp{.datetime =
        DateTime{.year=2025, .month=1, .day=1, .hour=19, .minute=26, .second=30}};
	std.debug.print("ts2={d}\n", .{ts2.seconds()});
}

const TimestampType = enum {
	unix,
	datetime,
};

//const Timestamp = union(TimestampType) {
const Timestamp = union(enum) {
	unix: i32,
	datetime: DateTime,

	const DateTime1 = struct {
		year: u16,
		month: u8,
		day: u8,
		hour: u8,
		minute: u8,
		second: u8,
	};

	fn seconds(self: Timestamp) u16 {
		switch (self) {
			.datetime => |dt| return dt.second,
			.unix => |ts| {
				const seconds_since_midnight: i32 = @rem(ts, 86400);
				return @intCast(@rem(seconds_since_midnight, 60));
			},
		}
	}
};
