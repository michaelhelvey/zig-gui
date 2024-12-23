import { libGuiImports, initializeWithInstance } from "./lib/bindings.js";

// import your wasm application:
WebAssembly.instantiateStreaming(fetch("zig-out/bin/gui.wasm"), {
  ...libGuiImports,
})
  .then((result) => {
    console.debug("successfully loaded and compiled module.wasm", result.instance);
    // initialize the web assembly instance
    initializeWithInstance(result.instance);
    // kick off the application
    result.instance.exports._start();
  })
  .catch((e) => {
    console.error("error loading or compiling module.wasm", e);
  });
