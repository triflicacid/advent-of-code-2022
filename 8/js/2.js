const fs = require('fs');

const get_up = (trs, n, x, y) => y < 0 ? [] : n <= trs[y][x] ? [trs[y][x]] : [trs[y][x]].concat(get_up(trs, n, x, y - 1));
const get_dn = (trs, n, x, y) => y >= trs.length ? [] : n <= trs[y][x] ? [trs[y][x]] : [trs[y][x]].concat(get_dn(trs, n, x, y + 1));
const get_lt = (trs, n, x, y) => x < 0 ? [] : n <= trs[y][x] ? [trs[y][x]] : [trs[y][x]].concat(get_lt(trs, n, x - 1, y));
const get_rt = (trs, n, x, y) => x >= trs[y].length ? [] : n <= trs[y][x] ? [trs[y][x]] : [trs[y][x]].concat(get_rt(trs, n, x + 1, y));
const scenic_score = (trs, x, y) =>
  get_up(trs, trs[y][x], x, y - 1).length *
  get_dn(trs, trs[y][x], x, y + 1).length *
  get_lt(trs, trs[y][x], x - 1, y).length *
  get_rt(trs, trs[y][x], x + 1, y).length;

(function () {
  const contents = fs.readFileSync("../input.txt").toString();
  const trees = contents.split("\r\n").filter(s => s.length > 0).map(r => r.split("").map(t => +t));
  const scores = trees.map((rw, y) => rw.map((n, x) => scenic_score(trees, x, y)));
  const max_score = Math.max(...scores.map(rw => Math.max(...rw)));
  console.log("Maximum Scenic Score: " + max_score);
})();