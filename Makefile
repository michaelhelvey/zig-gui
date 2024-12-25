default:
	zig build

format:
	zig fmt ./lib/*.zig
	zig fmt ./src/*.zig
