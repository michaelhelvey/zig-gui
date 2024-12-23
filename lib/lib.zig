const builtin = @import("builtin");
const std = @import("std");

extern fn consoleLog(i32, i32) void;

pub fn print(s: []const u8) void {
    if (builtin.cpu.arch == .wasm32) {
        const allocator = std.heap.wasm_allocator;
        const mem = allocator.alloc(u8, s.len) catch unreachable;
        @memcpy(mem, s);
        consoleLog(@intCast(@intFromPtr(mem.ptr)), @intCast(mem.len));
        allocator.free(mem);
    } else {
        const stderr = std.io.getStdErr();
        stderr.writeAll(s) catch unreachable;
    }
}
