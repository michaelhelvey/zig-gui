const builtin = @import("builtin");
const std = @import("std");
const gui = @import("gui");

const Window = gui.window.Window;

var window: *gui.window.windowImplementation() = undefined;

fn getDefaultAllocator() std.mem.Allocator {
    if (builtin.cpu.arch == .wasm32) {
        return std.heap.wasm_allocator;
    }

    // note: I'm running into problems with the mutex on GeneralPurposeAllocator.  Since I'm writing
    // a single threaded program, I'm going to ignore for now, and use the libc allocator, but I
    // wanna look into this at some point.
    return std.heap.c_allocator;
}

/// Initializes the program, opens & configures the initial window and opengl context, etc.
fn init() i32 {
    const allocator = getDefaultAllocator();
    window = Window.create(allocator, .{
        .height = 600,
        .width = 800,
        .title = "Demo",
        .vsync = true,
    }) orelse {
        gui.print("ERROR: could not create window\n", .{});
        return -1;
    };

    return 0;
}

export fn render() void {
    gui.gl.clearColor(.{ .r = 1.0, .g = 0.0, .b = 0.0, .a = 1.0 });
    gui.gl.clearColorBuffer();
    window.swap();
}

pub fn main() void {
    if (init() != 0) {
        gui.print("ERROR: could not init app\n", .{});
        return;
    }

    gui.renderLoop(window, render);
    gui.print("exiting application\n", .{});
}
