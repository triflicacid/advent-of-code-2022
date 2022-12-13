const fs = require("fs");
const { total_score, get_play } = require("./Utils.js");

(function () {
  const contents = fs.readFileSync("input.txt").toString();
  const plays = contents.split("\r\n").filter(x => x.length > 0).map(x => x.split(" "));
  const scores = plays.map(([p1, p2]) => total_score(p1, get_play(p1, p2)));
  console.log(scores.reduce((a, b) => a + b, 0));
})();