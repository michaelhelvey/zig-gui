const std = @import("std");
const builtin = @import("builtin");
const bindings = @import("./bindings.zig");
const c = @cImport({
    @cDefine("GL_SILENCE_DEPRECATION", {});
    @cInclude("OpenGL/gl.h");
    @cInclude("GLFW/glfw3.h");
});

const is_wasm = builtin.cpu.arch == .wasm32;

const Allocator = std.mem.Allocator;

pub fn windowImplementation() type {
    if (is_wasm) {
        return WasmWindow;
    }

    return GLFWWindow;
}

/// Generic Window interface that can be implemented by any windowing implementation.
pub const Window = struct {
    ptr: *anyopaque,
    vtable: *const VTable,

    const Self = @This();

    pub const WindowCreateOptions = struct {
        title: [*:0]const u8,
        height: i32,
        width: i32,
        vsync: bool = true,
    };

    pub const VTable = struct {
        /// Returns whether the given window should close.
        shouldClose: *const fn (ctx: *anyopaque) bool,

        /// Swaps the presentation and the back buffer, if double buffering is supported by the
        /// current platform.
        swap: *const fn (ctx: *anyopaque) void,
    };

    pub fn create(allocator: Allocator, options: WindowCreateOptions) ?*windowImplementation() {
        return windowImplementation().create(allocator, options);
    }

    pub fn shouldClose(self: *Self) bool {
        return self.vtable.shouldClose(self.ptr);
    }

    pub fn swap(self: *Self) void {
        return self.vtable.swap(self.ptr);
    }
};

pub const GLFWWindow = struct {
    window: *c.struct_GLFWwindow,

    const Self = @This();

    pub fn impl(self: *const Self) Window {
        return .{
            .ptr = self,
            .vtable = Window.VTable{
                .shouldClose = self.shouldClose,
                .swap = self.swap,
            },
        };
    }

    pub fn create(allocator: Allocator, options: Window.WindowCreateOptions) ?*Self {
        const self = allocator.create(Self) catch return null;

        if (c.glfwInit() != c.GLFW_TRUE) {
            return null;
        }

        self.window = c.glfwCreateWindow(
            options.width,
            options.height,
            options.title,
            null,
            null,
        ) orelse return null;

        c.glfwMakeContextCurrent(self.window);

        if (options.vsync) {
            c.glfwSwapInterval(1);
        }

        return self;
    }

    pub fn shouldClose(self: *Self) bool {
        return c.glfwWindowShouldClose(self.window) == c.GLFW_TRUE;
    }

    pub fn swap(self: *Self) void {
        c.glfwSwapBuffers(self.window);
    }
};

pub const WasmWindow = struct {
    call_count: u32,
    const Self = @This();

    pub fn impl(self: *const Self) Window {
        return .{
            .ptr = self,
            .vtable = Window.VTable{
                .shouldClose = self.shouldClose,
                .swap = self.swap,
            },
        };
    }

    pub fn create(allocator: Allocator, options: Window.WindowCreateOptions) ?*Self {
        const self = allocator.create(Self) catch return null;
        bindings.setCanvasSize(options.width, options.height);
        return self;
    }

    pub fn shouldClose(self: *Self) bool {
        _ = self;
        return false;
    }

    pub fn swap(self: *Self) void {
        _ = self;
    }
};

pub fn pollEvents() void {
    if (is_wasm) {
        return;
    }
    c.glfwPollEvents();
}
