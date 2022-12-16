const fs = require("fs");
const { Grid } = require("./Grid");

(function () {
  const contents = fs.readFileSync("../input.txt").toString();
  const grid = new Grid(10);
  const steps = contents.split("\r\n").filter(x => x.length > 0);
  steps.forEach(step => {
    const [dir, val] = step.split(" ");
    if (dir === "U") grid.mvUp(+val);
    else if (dir === "D") grid.mvDown(+val);
    else if (dir === "L") grid.mvLeft(+val);
    else if (dir === "R") grid.mvRight(+val);
  });
  // console.log(grid.toString(true));
  console.log("Tail visited " + grid.tail_visited.length + " locations");
})();