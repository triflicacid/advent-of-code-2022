const fs = require('fs');

(function () {
  const contents = fs.readFileSync("input.txt").toString();
  let sum = contents.split("\r\n").map(line => {
    const first = line.slice(0, Math.ceil(line.length / 2)), last = line.slice(Math.floor(line.length / 2));

    let in_both = null;
    for (let a of first) {
      for (let b of last) {
        if (a === b) {
          in_both = a;
          break;
        }
      }
    }
    if (in_both) {
      let ascii = in_both.charCodeAt(0);
      let val = ascii - (ascii <= 90 ? 64 - 26 : 96);
      return val;
    }
    return -1;
  }).filter(x => x >= 0).reduce((a, b) => a + b, 0);
  console.log(sum);
})();