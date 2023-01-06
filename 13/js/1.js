const fs = require('fs');
const { compare } = require('./utils');

(function () {
  const contents = fs.readFileSync("../input.txt").toString().trim();
  const pairs = contents.split("\r\n\r\n").map(x => x.trim().split("\r\n")).map((x, i) => ([i + 1, x]));
  const right = pairs.filter(([, [l, r]]) => compare(l, r));
  const sum = right.map(([i,]) => i).reduce((a, b) => a + b, 0);
  console.log("Sum of indices of correct pairs: " + sum);
})();