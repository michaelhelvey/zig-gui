const builtin = @import("builtin");
const bindings = @import("./bindings.zig");
const c = @cImport({
    @cDefine("GL_SILENCE_DEPRECATION", {});
    @cInclude("OpenGL/gl.h");
    @cInclude("GLFW/glfw3.h");
});

const is_wasm = builtin.cpu.arch == .wasm32;

pub const Color = struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,
};

pub fn clearColorBuffer() void {
    if (is_wasm) {
        bindings.clearColorBuffer();
        return;
    }
    // TODO: figure out some kind of cross-platform way to do the masks?
    c.glClear(c.GL_COLOR_BUFFER_BIT);
}

pub fn clearColor(color: Color) void {
    if (is_wasm) {
        bindings.clearColor(color.r, color.g, color.b, color.a);
        return;
    }
    c.glClearColor(color.r, color.g, color.b, color.a);
}
