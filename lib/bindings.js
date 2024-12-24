/** @type {WebAssembly.Instance} */
let _instance;

/** @type {HTMLCanvasElement} */
const canvas = document.getElementById("canvas");

/** @type {WebGLRenderingContext} */
const gl = canvas.getContext("webgl");

if (!gl) {
  throw new Error("could not initialize webgl");
}

export function initializeWithInstance(webAssemblyInstance) {
  _instance = webAssemblyInstance;
}

export const libGuiImports = {
  env: {
    consoleLog(offset, len) {
      const memory = _instance.exports.memory;
      const str = new TextDecoder("utf8").decode(new Uint8Array(memory.buffer, offset, len));
      console.log(str);
    },
    clearColor(r, g, b, a) {
      gl.clearColor(r, g, b, a);
    },
    clearColorBuffer() {
      gl.clear(gl.COLOR_BUFFER_BIT);
    },
    setCanvasSize(width, height) {
      console.log("setting canvas size");
      canvas.width = width;
      canvas.height = height;
    },
    pollEvents() {},
  },
};
