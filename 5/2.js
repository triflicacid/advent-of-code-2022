const fs = require('fs');

(function () {
  const contents = fs.readFileSync("input.txt").toString();
  let [cratesS, movesS] = contents.split("\r\n\r\n"); // String sections

  // Construct the crates
  const crates = [];
  let crateLines = cratesS.split("\r\n");
  crateLines.pop();
  crateLines.forEach(line => {
    for (let i = 0, j = 1; j <= line.length; i++, j += 4) {
      if (crates[i] === undefined) crates[i] = [];
      if (line[j] !== " ") crates[i].unshift(line[j]);
    }
  });

  // Loop through each move, and execute it
  movesS.split("\r\n").filter(s => s.length > 0).forEach(s => {
    s = s.replace(/(move|from|to)/g, ",");
    const nums = s.split(",").filter(x => x.length > 0).map(x => +x.trim());
    let [count, src, dst] = nums;
    let segment = crates[src - 1].splice(crates[src - 1].length - count, count);
    crates[dst - 1].push(...segment);
  });

  const tops = crates.reduce((str, crate) => str + crate.pop(), "");
  console.log(tops);
})();