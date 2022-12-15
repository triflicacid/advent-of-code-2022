const fs = require('fs');

const all_up = (trs, n, x, y) => (y < 0) || ((n > trs[y][x]) && all_up(trs, n, x, y - 1));
const all_dn = (trs, n, x, y) => (y >= trs.length) || ((n > trs[y][x]) && all_dn(trs, n, x, y + 1));
const all_rt = (trs, n, x, y) => (x >= trs[y].length) || ((n > trs[y][x]) && all_rt(trs, n, x + 1, y));
const all_lt = (trs, n, x, y) => (x < 0) || ((n > trs[y][x]) && all_lt(trs, n, x - 1, y));

(function () {
  const contents = fs.readFileSync("../input.txt").toString();
  const trees = contents.split("\r\n").filter(s => s.length > 0).map(r => r.split("").map(t => +t));
  // console.log(trees.map(rw => rw.join("")).join("\r\n"))

  const visible = trees.map((rw, y) => rw.map((n, x) =>
    all_up(trees, n, x, y - 1) || all_dn(trees, n, x, y + 1) ||
    all_lt(trees, n, x - 1, y) || all_rt(trees, n, x + 1, y)
  ));
  // console.log(visible.map(rw => rw.map(b => +b).join("")).join("\r\n"))

  const count = visible.reduce((a, rw) => a + rw.filter(n => n).length, 0);
  console.log("Visible: " + count);
})();