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

  const start = Date.now(),
    max = filename.includes("Sample") ? 20 : 4000000,
    unscanned = N.getUnscanned(0, max),
    end = Date.now();
  if (unscanned.length > 1) {
    console.log(`Multiple possible locations found:\n` + unscanned.map(([x, y]) => `(${x},${y})`).join(','));
  } else {
    const [x, y] = unscanned[0], freq = x * 4000000 + y;
    console.log(`Distress beacon must be at (${x},${y}) with a tuning frequency of ${freq}`);
  }
  console.log("Time: " + (end - start) + "ms");
})();