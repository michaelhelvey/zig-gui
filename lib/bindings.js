let _instance;

export function initializeWithInstance(webAssemblyInstance) {
  _instance = webAssemblyInstance;
}

export const libGuiImports = {
  env: {
    consoleLog: (offset, len) => {
      const memory = _instance.exports.memory;
      const str = new TextDecoder("utf8").decode(new Uint8Array(memory.buffer, offset, len));
      console.log(str);
    },
  },
};
