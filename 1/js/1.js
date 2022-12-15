const NEWLINE = "\r\n";

const fs = require("fs");

(function () {
  const contents = fs.readFileSync("../input.txt").toString();
  const cals = contents.split(NEWLINE + NEWLINE).map(s => s.split(NEWLINE).map(x => +x).reduce((a, b) => a + b, 0));
  console.log(Math.max.apply(this, cals));
})();