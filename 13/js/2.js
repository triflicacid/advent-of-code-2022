const fs = require('fs');
const { compare } = require('./utils');

(function () {
  const contents = fs.readFileSync("../input.txt").toString().trim();
  const lists = contents.split("\r\n").map(x => x.trim()).filter(x => x.length > 0); // Extract lists
  const markers = ["[[2]]", "[[6]]"];
  lists.push(...markers); // Add markers
  const sorted = lists.sort((a, b) => compare(a, b) ? -1 : 0); // Sort
  const indices = markers.map(m => sorted.indexOf(m) + 1); // Get indices of markers
  const key = indices.reduce((a, b) => a * b, 1); // Calculate key by taking the product
  console.log("Decoder key: " + key);
})();