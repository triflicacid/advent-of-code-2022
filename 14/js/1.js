const fs = require("fs");
const Formation = require("./Formation");

(function () {
  const contents = fs.readFileSync("../input.txt").toString();
  const paths = contents.trim().split("\r\n").map(p => p.split(" -> ").map(c => c.split(",").map(n => +n)));

  // Construct formation
  const F = new Formation();
  paths.forEach(p => F.fillRockPath(p));

  // Fill sand
  let count = 0;
  while (F.dropSand()) count++;
  // console.log(F.toString());

  console.log(`${count} units of sand came to rest before it started flowing into the abyss.`);
})();