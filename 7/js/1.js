const fs = require('fs');
const { Directory } = require("./FileSystem.js");

(function () {
  const contents = fs.readFileSync("../input.txt").toString();
  const root = new Directory("/");
  root.populateFromScript(contents);

  const dirs = [];
  (function fun(cwd) {
    cwd.children.forEach(ch => {
      if (ch instanceof Directory) {
        if (ch.getSize() <= 100000) dirs.push(ch);
        fun(ch);
      }
    });
  })(root);
  let total = 0;
  dirs.forEach(d => {
    let size = d.getSize();
    console.log(`${d.path} : ${size}`);
    total += size;
  });
  console.log(`Total: ${total}`);
})();