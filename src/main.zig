const std = @import("std");
const Display = @import("display.zig").Display;
const Bitmap = @import("bitmap.zig").Bitmap;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const leaked = gpa.deinit();
        if (leaked == .leak) {
            @panic("memory leak");
        }
    }

    var bitmap = try Bitmap.create(allocator, 64, 32);
    defer bitmap.free();
    _ = bitmap.setPixel(5, 5);

    var display = try Display.create("CHIP-8", 600, 300, bitmap.width, bitmap.height);
    defer display.free();

    while (display.open) {
        display.input();
        display.draw(&bitmap);
    }
}
