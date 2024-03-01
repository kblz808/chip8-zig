const std = @import("std");
const Display = @import("display.zig").Display;

pub fn main() !void {
    var display = try Display.create("CHIP-8", 600, 300);
    defer display.free();

    while (display.open) {
        display.input();
    }
}
