const fs = require('fs');
const { Directory } = require("./FileSystem.js");

const TOTAL_SIZE = 70000000;
const NEEDED_SIZE = 30000000;
const TARGET = TOTAL_SIZE - NEEDED_SIZE;

(function () {
  const contents = fs.readFileSync("../input.txt").toString();
  const root = new Directory("/");
  root.populateFromScript(contents);

  let excess = root.getSize() - TARGET;
  let best = null, best_size = Infinity;
  (function explore(dir) {
    let size = dir.getSize();
    if (size < best_size && size >= excess) {
      best = dir;
      best_size = size;
    }
    dir.children.forEach(ch => ch instanceof Directory && explore(ch));
  })(root);
  console.log(`${best.path} : ${best_size}`);
})();