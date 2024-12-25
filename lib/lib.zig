const builtin = @import("builtin");
const std = @import("std");
const logger = @import("./logger.zig");
const bindings = @import("./bindings.zig");

pub const is_wasm = builtin.cpu.arch == .wasm32;
pub const window = @import("./window.zig");
pub const gl = @import("./gl.zig");
pub const print = logger.print;

pub fn renderLoop(w: *window.windowImplementation(), render: *const fn () callconv(.C) void) void {
    // in wasm: start the main loop from JS:
    if (is_wasm) {
        bindings.renderLoop();
        return;
    }

    // otherwise, we can actually call render in a loop using GLFW:
    while (!w.shouldClose()) {
        render();
        window.pollEvents();
    }
}
