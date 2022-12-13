const fs = require('fs');

(function () {
  const contents = fs.readFileSync("input.txt").toString();
  let lines = contents.split("\r\n");
  const groups = [[]];
  lines.forEach(line => {
    if (groups[groups.length - 1].length === 3) {
      groups.push([line]);
    } else {
      groups[groups.length - 1].push(line);
    }
  });
  const values = groups.filter(group => group.length === 3).map(group => {
    const g0 = group[0].split("");
    const g1 = group[1].split("");
    const g2 = group[2].split("");
    const int = g0.filter(x => g1.includes(x) && g2.includes(x));
    const ascii = int[0].charCodeAt(0);
    const val = ascii - (ascii <= 90 ? 64 - 26 : 96);
    return val;
  });
  const sum = values.reduce((a, b) => a + b, 0);
  console.log(sum);
})();