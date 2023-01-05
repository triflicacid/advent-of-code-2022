const START = 0, END = 27;

/** Get starting vertex. NB, assumes only one such exists. */
function get_start(map) {
  const y = map.findIndex(r => r.some(v => v === START));
  const x = map[y].findIndex(v => v === START);
  return [x, y];
}

/** Get ending vertex. NB, assumes only one such exists. */
function get_end(map) {
  const y = map.findIndex(r => r.some(v => v === END));
  const x = map[y].findIndex(v => v === END);
  return [x, y];
}

/** Collapse a 2D array into 1D */
function collapse(arr2D) {
  return arr2D.reduce((a, c) => a.concat(c), []);
}

/** Get `height` value of a character */
function get_val(c) {
  if (c === 'S') return START;
  if (c === 'E') return END;
  return c.charCodeAt(0) - 96;
}

/** Create `map` from raw text */
function create_map(text) {
  return text.split("\r\n").filter(x => x.length > 0).map(r => r.split("").map(get_val));
}

/** Get possible new locations from a location  */
function get_adj(map, x, y) {
  const h = map[y][x].h;
  const adj = [];
  if (y > 0 && map[y - 1][x].h - 1 <= h) adj.push([x, y - 1]);
  if (y < map.length - 1 && map[y + 1][x].h - 1 <= h) adj.push([x, y + 1]);
  if (x > 0 && map[y][x - 1].h - 1 <= h) adj.push([x - 1, y]);
  if (x < map[y].length - 1 && map[y][x + 1].h - 1 <= h) adj.push([x + 1, y]);
  return adj;
}

/**
 * Get shortest path from <start> to <end> in map <map>. WARNING mutates argument properties.
 * 
 * @param {number[][]} map Height map
 * @param {number[]} start Starting co-ordinate
 * @param {number[]} end Ending co-ordinate
*/
function get_shortest_path(map, start, end) {
  // == PREPARE ARGS ==
  map = map.map((r, y) => r.map((h, x) => ({
    x, y,
    h, // Height value
    done: false, // Has this vertex been visited?
    len: Infinity, // Length of shortest path
    prev: undefined, // Previous vertex, co-ordinates
  })));
  start = map[start[1]][start[0]]; // Get vertex from map
  end = map[end[1]][end[0]]; // Get vertex from map

  start.len = 0;
  let next = start; // Next vertex to consider
  while (true) {
    const cur = next;
    cur.done = true;
    next = null; // Clear next
    if (cur === end) break; // We have reached the end.
    // Get vertices to visit
    const adj = get_adj(map, cur.x, cur.y);
    for (let pnext of adj) {
      const pv = map[pnext[1]][pnext[0]];
      if (!pv.done && cur.len + 1 < pv.len) {
        pv.len = cur.len + 1;
        pv.prev = [cur.x, cur.y];
        if (pv === end) { // If we spy the end, go there and break.
          next = pv;
          break;
        }
      }
    }
    if (!next) {
      const pnext = collapse(map.map(r => r.filter(v => !v.done && v.prev !== undefined)));
      if (pnext.length === 0) break; // DONE
      next = pnext.reduce((min, c) => c.len < min.len ? c : min, pnext[0]);
    }
  }

  if (end.prev === undefined) {
    return []; // No path?
  } else {
    const path = [];
    for (let last = end; last.prev; last = map[last.prev[1]][last.prev[0]]) {
      path.push(last);
    }
    return path.map(v => ([v.x, v.y])).reverse();
  }
}

module.exports = { get_start, get_end, collapse, create_map, get_shortest_path };