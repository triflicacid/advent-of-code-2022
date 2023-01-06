function dist(x0, y0, x1, y1) {
  return Math.abs(x1 - x0) + Math.abs(y1 - y0);
}

class Network {
  static NOTHING = -1;
  static BEACON = 1;
  static SENSOR = 2;

  constructor() {
    this.stuff = new Map(); // "x,y" => number

    // Min.max positions a thing is in
    this._min = [Infinity, 0];
    this._max = [-Infinity, 0];
  }

  /** Get thing at (x,y) */
  getAt(x, y) {
    return this.stuff.get(x + "," + y) ?? Network.NOTHING;
  }

  /** Set thing at (x,y) */
  setAt(x, y, item) {
    if (item === Network.NOTHING) {
      this.stuff.delete(x + "," + y);
    } else {
      this.stuff.set(x + "," + y, item);
      if (x < this._min[0]) this._min[0] = x;
      if (x > this._max[0]) this._max[0] = x;
      if (y > this._max[1]) this._max[1] = y;
    }
  }

  /** Get closest beacon to (x,y): return [x, y, dist] */
  nearestBeacon(sx, sy) {
    const beacons = Array.from(this.stuff.entries()).filter(([, i]) => i === Network.BEACON).map(([p,]) => p.split(",").map(n => +n));
    const dists = beacons.map(([x, y]) => [x, y, dist(sx, sy, x, y)]);
    const min = dists.reduce((p, c) => p[2] < c[2] ? p : c, dists[0]);
    return min;
  }

  /** Return array of objects: sensor, nearest beacon, and the distance */
  scan() {
    return Array.from(this.stuff.entries()).filter(([, i]) => i === Network.SENSOR).map(([l,]) => l.split(',').map(n => +n)).map(([x, y]) => {
      const [bx, by, d] = this.nearestBeacon(x, y);
      return {
        sensor: [x, y],
        beacon: [bx, by],
        dist: d,
      };
    });
  }

  /** Return array of positions of all unscanned positions, where `x` and `y` are between the given bounds */
  getUnscanned(min, max) {
    const scan = this.scan(), poss = new Set(); //[];
    scan.forEach(({ dist: d, sensor: [sx, sy] }) => {
      // Test every cell directly on the outside of every diamond
      for (let x = sx - d; x <= sx + d; x++) {
        if (x < min || x > max) continue;
        const hh = d - Math.abs(sx - x); // Calculate height of diamond at this `x` position
        for (let y of [sy - hh - 1, sy + hh + 1]) { // Get `y` coordinates of top and bottom
          if (y < min || y > max) continue;
          // Check if scanned
          const scanned = scan.some(o => dist(...o.sensor, x, y) <= o.dist);
          if (!scanned) poss.add(x + "," + y);
        }
      }
    });
    return Array.from(poss).map(x => x.split(",").map(n => +n));
  }

  /** Return array of x-coordinates of all scanned positions on the given row */
  getScanned(y) {
    const scan = this.scan(), xs = new Set()
    scan.forEach(({ dist: d, sensor: [sx, sy] }) => {
      // In diamond?
      if (y >= sy - d && y <= sy + d) {
        const w = d - Math.abs(sy - y);
        for (let x = sx - w; x <= sx + w; x++) xs.add(x);
      }
    });
    // Remove Sensors and Beacons
    scan.forEach(({ beacon: [bx, by], sensor: [sx, sy] }) => {
      if (by === y) xs.delete(bx);
      if (sy === y) xs.delete(sx);
    });
    return Array.from(xs);
  }

  /**
   * Return string representation
   * 
   * @param {boolean} expand Expand grid to fit in all scanned locations?
   * @param {number} y If present, return string of that row, else return entire grid
  */
  toString(expand = false, y = undefined) {
    // Get nearest beacon to every sensor -- [sensor x, sensor y, scan radius]
    const scan = this.scan();
    let minx, miny, maxx, maxy;
    if (expand) {
      minx = Infinity, miny = Infinity, maxx = -Infinity, maxy = -Infinity;
      scan.forEach(({ sensor: s, dist: d }) => {
        if (s[0] - d < minx) minx = s[0] - d;
        if (s[0] + d > maxx) maxx = s[0] + d;
        if (s[1] - d < miny) miny = s[1] - d;
        if (s[1] + d > maxy) maxy = s[1] + d;
      });
    } else {
      ([minx, miny] = this._min);
      ([maxx, maxy] = this._max);
    }
    if (y === undefined) {
      const rows = Array.from({ length: maxy - miny + 1 }, () => "");
      const pad = Math.max(miny.toString().length, maxy.toString().length);
      for (let x = minx; x <= maxx; x++) {
        for (let y = miny; y <= maxy; y++) {
          if (x === minx) rows[y - miny] += y.toString().padStart(pad, " ") + " ";
          let char = ".", here = this.getAt(x, y);
          if (here === Network.BEACON) char = "B"; // Beacon
          else if (here === Network.SENSOR) char = "S"; // Sensor
          else if (scan.some(o => dist(...o.sensor, x, y) <= o.dist)) char = "#"; // Scanned!
          rows[y - miny] += char;
        }
      }
      return rows.join("\n");
    } else {
      let row = "";
      for (let x = minx; x <= maxx; x++) {
        let char = ".", here = this.getAt(x, y);
        if (here === Network.BEACON) char = "B"; // Beacon
        else if (here === Network.SENSOR) char = "S"; // Sensor
        else if (scan.some(o => dist(...o.sensor, x, y) <= o.dist)) char = "#"; // Scanned!
        row += char;
      }
      return row;
    }
  }
}

module.exports = Network;