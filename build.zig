const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const libgui = b.addModule("libgui", .{
        .root_source_file = b.path("./lib/lib.zig"),
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "gui",
        .root_source_file = b.path("./src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // TODO: make this more cross-platform somehow
    exe.linkLibC();
    exe.addIncludePath(std.Build.LazyPath{ .cwd_relative = "/opt/homebrew/include" });
    exe.addLibraryPath(std.Build.LazyPath{ .cwd_relative = "/opt/homebrew/lib" });
    exe.linkSystemLibrary("glfw3");
    exe.linkFramework("OpenGL");

    b.installArtifact(exe);

    exe.root_module.addImport("gui", libgui);

    const wasm = b.addExecutable(.{
        .name = "gui",
        .root_source_file = b.path("./src/main.zig"),
        .target = b.resolveTargetQuery(.{ .cpu_arch = .wasm32, .os_tag = .freestanding }),
        .optimize = optimize,
    });
    wasm.entry = .disabled;
    wasm.rdynamic = true;
    wasm.root_module.addImport("gui", libgui);

    b.installArtifact(wasm);
}
