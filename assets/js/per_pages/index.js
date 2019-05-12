const requireModule = require.context(".", false, /\.js$/);
const modules = {};
require("video.js");
requireModule
  .keys()
  .filter(fileName => fileName !== "./index.js")
  .forEach(
    fileName =>
      (modules[fileName.replace("./", "").replace(".js", "")] = requireModule(
        fileName
      ))
  );

export default function() {
  const jsFile = document.querySelector("body").dataset.jsFile;
  const f = modules[jsFile];

  if (f && f.default) {
    f.default();
  }
}
