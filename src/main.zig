const std = @import("std");

const Display = @import("display.zig").Display;
const Bitmap = @import("bitmap.zig").Bitmap;
const Device = @import("device.zig").Device;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const leaked = gpa.deinit();
        if (leaked == .leak) {
            @panic("memory leak");
        }
    }

    var device = try Device.create(allocator);
    defer device.free();

    if (!device.loadROM("./roms/blits.rom")) {
        std.debug.print("failed to load chip8 rom\n", .{});
        return;
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
