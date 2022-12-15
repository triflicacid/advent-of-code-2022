const fs = require('fs');

(function () {
  const contents = fs.readFileSync("../input.txt").toString();
  let [cratesS, movesS] = contents.split("\r\n\r\n");

  // Construct the crates
  const crates = [];
  let crateLines = cratesS.split("\r\n");
  crateLines.pop();
  crateLines.forEach((line, i) => {
    for (let i = 0, j = 1; j <= line.length; i++, j += 4) {
      if (crates[i] === undefined) crates[i] = [];
      if (line[j] !== " ") crates[i].unshift(line[j]);
    }
  });

  // Loop through each move, and execute it
  movesS.split("\r\n").forEach(s => {
    s = s.replace(/(move|from|to)/g, ",");
    const nums = s.split(",").filter(x => x.length > 0).map(x => +x.trim());
    let [count, src, dst] = nums;
    while (count > 0) {
      let x = crates[src - 1].pop();
      crates[dst - 1].push(x);
      count--;
    }
  });

  const tops = crates.reduce((str, crate) => str + crate.pop(), "");
  console.log(tops);
})();