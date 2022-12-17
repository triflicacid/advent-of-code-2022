const fs = require('fs');
const { createMonkey, monkeysToString, playRound } = require("./Monkey");

(function () {
  const contents = fs.readFileSync("../input.txt").toString();
  const notes = contents.split("\r\n\r\n").filter(x => x.length > 0).map(m => m.split("\r\n").filter(x => x.length > 0));

  const monkeys = notes.map(createMonkey);
  const T = x => Math.floor(x / 3);
  for (let i = 0; i < 20; i++) playRound(monkeys, T);

  console.log("===== ITEMS =====")
  console.log(monkeysToString(monkeys));

  // Print times inspected
  console.log("===== COUNT =====");
  monkeys.forEach((mk, i) => console.log(`Monkey ${i} inspected items ${mk.count} times.`));
  const counts = monkeys.map(mk => mk.count);
  const max1 = Math.max(...counts);
  counts.splice(counts.indexOf(max1), 1);
  const max2 = Math.max(...counts);
  console.log(`\nMost active: ${max1} and ${max2}\nMonkey Business: ${max1 * max2}`);
})();