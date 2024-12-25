const builtin = @import("builtin");
const std = @import("std");
const bindings = @import("./bindings.zig");

const is_wasm = builtin.cpu.arch == .wasm32;

/// Prints to the debug logging output default for the platform, and flushes the buffer, if
/// required. Panics on error.
///
/// This functions requires an allocator because some platforms (e.g. web) lack an ability to write
/// out arbitrary bytes, and so we must assemble the entire output stream before emitting it.
pub fn print(comptime format: []const u8, args: anytype) void {
    if (is_wasm) {
        const buf = std.fmt.allocPrint(std.heap.wasm_allocator, format, args) catch unreachable;
        bindings.consoleLog(@intCast(@intFromPtr(buf.ptr)), @intCast(buf.len));
        std.heap.wasm_allocator.free(buf);
    } else {
        const stderr_file = std.io.getStdErr().writer();
        var bw = std.io.bufferedWriter(stderr_file);
        const stderr = bw.writer();

        stderr.print(format, args) catch unreachable;
        bw.flush() catch unreachable;
    }
}
