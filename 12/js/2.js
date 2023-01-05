const fs = require("fs");
const { create_map, get_shortest_path, get_end } = require("./utils");

(function () {
  const contents = fs.readFileSync("../input.txt").toString();
  const map = create_map(contents);

  const end = get_end(map);
  const as = []; // Position of every vertex of height 'a' (1)
  map.forEach((r, y) => {
    r.forEach((h, x) => {
      if (h === 1) as.push([x, y]);
    });
  });


  let min, minLength = Infinity;
  as.forEach(a => {
    // Don't check paths which are further away than the shortest path - there's no way to beat this
    const dist = Math.max(Math.abs(end[0] - a[0]), Math.abs(a[1] - a[1]));
    if (dist <= minLength) {
      let path = get_shortest_path(map, a, end);
      if (path.length > 0 && path.length < minLength) { // Path is valid, and it's the new minimum.
        minLength = path.length;
        min = path;
      }
    }
  });

  console.log("Path:", min.map(([x, y]) => `[${x},${y}]`).join(','));
  console.log(`Path length: ${min.length}`);
})();