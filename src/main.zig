const builtin = @import("builtin");
const std = @import("std");
const gui = @import("gui");

const Window = gui.window.Window;

fn createDefaultAllocator() std.mem.Allocator {
    if (builtin.cpu.arch == .wasm32) {
        return std.heap.wasm_allocator;
    }

    // note: I'm running into problems with the mutex on GeneralPurposeAllocator.  Since I'm writing
    // a single threaded program, I'm going to ignore for now, and use the libc allocator, but I
    // wanna look into this at some point.
    return std.heap.c_allocator;
}

pub fn main() void {
    const allocator = createDefaultAllocator();

    // Cross-platform logging w/ format example:
    const name = "Michael";
    gui.print(allocator, "hello, {s}\n", .{name});

    // Draw some stuff to the screen:
    const window = Window.create(allocator, .{
        .height = 600,
        .width = 800,
        .title = "Demo",
        .vsync = true,
    }) orelse {
        gui.print(allocator, "ERROR: could not create window\n", .{});
        return;
    };

    while (!window.shouldClose()) {
        gui.gl.clearColor(.{ .r = 1.0, .g = 0.0, .b = 0.0, .a = 1.0 });
        gui.gl.clearColorBuffer();
        window.swap();

        gui.window.pollEvents();
    }

    gui.print(allocator, "exiting application\n", .{});
}
