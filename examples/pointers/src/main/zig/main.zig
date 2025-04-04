const std = @import("std");

pub fn main() void {
	var user = User{
		.id = 1,
		.power = 100,
	};

	// no longer needed
	// user.power += 1;

	// user -> &user
	levelUp(&user);
	std.debug.print("User {d} has power of {d}\n", .{user.id, user.power});
}

// User -> *User
fn levelUp(user: *User) void {
	user.power += 1;
}

pub const User = struct {
	id: u64,
	power: i32,
};
