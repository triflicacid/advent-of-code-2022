class Formation {
  static NOTHING = -1;
  static FLOOR = 1;
  static SAND = 2;
  static ROCK = 3;

  constructor() {
    this.stuff = new Map(); // map position "x,y" to a thing (e.g. rock)
    this.src = 500; // X-position of sand source
    this.floor = Infinity; // Rock floor if this value below the highest scanned rock y-coordinate

    // Min,max coordinates of where rock (NOT the floor) is located
    this._min = [Infinity, 0];
    this._max = [-Infinity, 0];
  }

  /** Return item at (x, y) */
  getAt(x, y) {
    if (isFinite(this.floor) && y >= this.getFloor()) return Formation.FLOOR;
    return this.stuff.get(x + "," + y) ?? Formation.NOTHING;
  }

  /** Insert item at (x, y) */
  insertAt(x, y, item) {
    this.stuff.set(x + "," + y, item);
    if (item === Formation.ROCK) {
      if (x < this._min[0]) this._min[0] = x;
      if (x > this._max[0]) this._max[0] = x;
      if (y > this._max[1]) this._max[1] = y;
    }
  }

  /** Remove item at (x, y) */
  removeAt(x, y) {
    this.stuff.delete(x + "," + y);
  }

  /** Return if there is a void below (x, y) */
  isVoidBelow(x, y) {
    return !isFinite(this.floor) && y > this._max[1];
  }

  /** Get Y-coordinate of the floor */
  getFloor() {
    return isFinite(this.floor) ? this.floor + this._max[1] : Infinity;
  }

  /** Create a vertical or horizontal line of rock between two co-ordinates */
  fillRockLine(x0, y0, x1, y1) {
    if (x0 === x1) { // Vertical line
      let delta = y0 < y1 ? 1 : -1;
      for (let x = x0, y = y0; ; y += delta) {
        this.insertAt(x, y, Formation.ROCK);
        if (y === y1) break;
      }
    } else if (y0 === y1) { // Horizontal line
      let delta = x0 < x1 ? 1 : -1;
      for (let x = x0, y = y0; ; x += delta) {
        this.insertAt(x, y, Formation.ROCK);;
        if (x === x1) break;
      }
    }
  }

  /** Fill a path of rock -- collection of line segments */
  fillRockPath(coords) {
    for (let i = 0; i < coords.length - 1; i++) this.fillRockLine(...coords[i], ...coords[i + 1]);
  }

  /** Drop a grain of sand from <src>. Return boolean indicating if the sand was inserted. */
  dropSand() {
    let x = this.src, y = 0;
    if (this.getAt(x, y) !== -1) return false; // Source is blocked
    while (true) {
      // Below?
      if (this.getAt(x, y + 1) === Formation.NOTHING) y++;
      else if (this.getAt(x - 1, y + 1) === Formation.NOTHING) x--, y++;
      else if (this.getAt(x + 1, y + 1) === Formation.NOTHING) x++, y++;
      else break;
      if (this.isVoidBelow(x, y)) return false; // Bottomless void
    }
    this.insertAt(x, y, Formation.SAND);
    return true;
  }

  /** Return string representation */
  toString() {
    const [minx,] = this._min;
    const [maxx, maxsy] = this._max, maxy = isFinite(this.floor) ? this.getFloor() : maxsy;
    const rows = Array.from({ length: maxy + 1 }, () => "");
    for (let x = minx; x <= maxx; x++) {
      for (let y = 0; y <= maxy; y++) {
        let char = '.';
        const here = this.getAt(x, y);
        if (here === Formation.ROCK || here === Formation.FLOOR) char = '#';
        else if (here === Formation.SAND) char = 'o';
        else if (x === this.src && y === 0) char = '+';
        rows[y] += char;
      }
    }
    return rows.join("\n");
  }
}

module.exports = { Formation };