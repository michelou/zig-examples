const std = @import("std");

pub fn main() void {
	const leto = User{
		.id = 1,
		.power = 9001,
		.manager = null,
	};

	const duncan = User{
		.id = 1,
		.power = 9001,
		// changed from leto -> &leto
		.manager = &leto,
	};

	std.debug.print("{any}\n{any}\n", .{leto, duncan});
}

pub const User = struct {
	id: u64,
	power: i32,
	// changed from ?const User -> ?*const User
	manager: ?*const User,
};
