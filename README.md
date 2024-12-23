# zig-gui

Exploring cross-platform GUI development in zig / opengl / wasm. Currently just the beginnings of a
skeleton -- I don't really know what I'm doing, but eventually I want to build out a cross platform
renderer based on opengl/webgl.

## Getting Started

**To run the example**:

`zig build && ./zig-out/bin/gui` will run the native application. (TODO: include install
instructions for glfw and opengl and the binary dependencies of the native app).
`zig build && python -m http.server` and opening `localhost:8000` will run the same app as a web
app.

This repository contains both the actual framework (`./lib/`) and the example app that uses the
framework (`./src/`). If you wanted to use this framework in "your app", you would install this
repository as a git submodule, use your build.zig to create a module from `submodule/lib` just as
the build.zig in this repository does, and then create your own index.html & script.js file to call
your app (which will build `libgui` when it builds, just as this repository does).

Eventually I'd like to figure out how to use the zig package manager or otherwise improve this
install experience to create something a little more standardized.
