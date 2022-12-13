const fs = require('fs');
const GROUP_SIZE = 4;

(function () {
  const contents = fs.readFileSync("input.txt").toString().trimEnd();

  let chars = (function (group_size) {
    for (let i = 0; i < contents.length; i++) {
      let sub = contents.substring(i, i + group_size);
      let set = new Set(sub);
      if (set.size === group_size) return i + group_size;
    }
    return -1;
  })(GROUP_SIZE);

  console.log(chars);
})();