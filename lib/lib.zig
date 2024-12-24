const builtin = @import("builtin");
const std = @import("std");
const logger = @import("./logger.zig");

pub const window = @import("./window.zig");
pub const gl = @import("./gl.zig");
pub const print = logger.print;
