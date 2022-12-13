const NEWLINE = "\r\n";

const fs = require("fs");

(function (file) {
  const contents = fs.readFileSync(file).toString();
  const cals = contents.split(NEWLINE + NEWLINE).map(s => s.split(NEWLINE).map(x => +x).reduce((a, b) => a + b, 0));
  console.log(Math.max.apply(this, cals));
})("input.txt");