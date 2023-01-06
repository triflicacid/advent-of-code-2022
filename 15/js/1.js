const fs = require('fs');
const Network = require('./Network');

const filename = "../input.txt";

(function () {
  const contents = fs.readFileSync(filename).toString();
  const pos = contents.trim().split("\r\n").map(l => l.split(":").map(x => x.split("at ")[1].split(", ").map(x => +x.split("=")[1])));

  const N = new Network();
  pos.forEach(([s, b]) => {
    N.setAt(...s, Network.SENSOR);
    N.setAt(...b, Network.BEACON);
  });

  const y = filename.includes("Sample") ? 10 : 2000000;
  const start = Date.now();
  // const row = N.toString(true, y), count = row.split('').reduce((tot, c) => tot + (c === '#'), 0);
  const xs = N.getScanned(y), count = xs.length;
  const end = Date.now();
  console.log(`On y=${y}, there are ${count} locations where the beacon isn't`);
  console.log("Time: " + (end - start) + "ms");
})();