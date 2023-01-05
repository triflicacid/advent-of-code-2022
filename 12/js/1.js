const fs = require("fs");
const { get_start, get_end, create_map, get_shortest_path } = require("./utils");

(function () {
  const contents = fs.readFileSync("../inputSample.txt").toString();
  const map = create_map(contents);

  const path = get_shortest_path(map, get_start(map), get_end(map));
  console.log("Path:", path.map(([x, y]) => `[${x},${y}]`).join(','));
  console.log(`Path length: ${path.length}`);
})();