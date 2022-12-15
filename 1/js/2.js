const NEWLINE = "\r\n";

const fs = require("fs");

const remove = (x, arr) => arr.splice(arr.indexOf(x), 1);

(function () {
  const contents = fs.readFileSync("../input.txt").toString();
  const cals = contents.split(NEWLINE + NEWLINE).map(s => s.split(NEWLINE).map(x => +x).reduce((a, b) => a + b, 0));
  const max1 = Math.max(...cals);
  remove(max1, cals);
  const max2 = Math.max(...cals);
  remove(max2, cals);
  const max3 = Math.max(...cals);

  console.log(max1 + max2 + max3);
})();
