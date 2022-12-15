const fs = require('fs');

(function () {
  const contents = fs.readFileSync("../input.txt").toString();
  const pairs = contents.split("\r\n").filter(s => s.length !== 0).map(s => s.split(",").map(s => s.split("-").map(s => +s)));
  const overlap = pairs.filter(([[a, b], [x, y]]) => (a <= x && b >= y) || (a >= x && b <= y) || (a <= y && x <= b));
  console.log(overlap.length);
})();