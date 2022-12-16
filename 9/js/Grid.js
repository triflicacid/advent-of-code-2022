/** Map difference between the head and the tail into where the tail should move */
const changes = {
  "0,2": [0, 1],
  "1,2": [1, 1],
  "2,2": [1, 1],
  "2,1": [1, 1],
  "2,0": [1, 0],
  "2,-1": [1, -1],
  "2,-2": [1, -1],
  "1,-2": [1, -1],
  "0,-2": [0, -1],
  "-1,-2": [-1, -1],
  "-2,-2": [-1, -1],
  "-2,-1": [-1, -1],
  "-2,0": [-1, 0],
  "-2,1": [-1, 1],
  "-2,2": [-1, 1],
  "-1,2": [-1, 1],
};

class Grid {
  constructor(length) {
    this.rope = Array.from({ length }, () => ([0, 0])); // head, ..., tail
    this.tail_visited = [[...this.rope[0]]];
    this._min = [0, 0];
    this._max = [1, 1];
  }

  /** Update position of the head of the rope: |dx| <= 1, |dy| <= 1 */
  _mv(dx, dy) {
    this.rope[0] = [this.rope[0][0] + dx, this.rope[0][1] + dy];
    for (let i = 0; i < this.rope.length - 1; i++) {
      let head = this.rope[i], tail = this.rope[i + 1];
      const diff = (head[0] - tail[0]) + "," + (head[1] - tail[1]);
      const delta = changes[diff];
      if (delta) {
        tail = [tail[0] + delta[0], tail[1] + delta[1]];
        this.rope[i + 1] = tail;
      }
    }

    // Only the tail!
    const tail = this.rope[this.rope.length - 1];
    let beenbefore = this.tail_visited.find(([x, y]) => tail[0] === x && tail[1] === y);
    if (!beenbefore) this.tail_visited.push(tail);

    const xs = this.rope.map(([x, _]) => x), ys = this.rope.map(([_, y]) => y);
    this._min = [Math.min(...xs, this._min[0]), Math.min(...ys, this._min[0])];
    this._max = [Math.max(...xs, this._max[0]), Math.max(...ys, this._max[0])];
  }

  /** Move head RIGHT by `steps` places */
  mvRight(steps) {
    for (let i = 0; i < steps; i++) this._mv(1, 0);
  }

  /** Move head LEFT by `steps` places */
  mvLeft(steps) {
    for (let i = 0; i < steps; i++)  this._mv(-1, 0);
  }

  /** Move head UP by `steps` places */
  mvUp(steps) {
    for (let i = 0; i < steps; i++) this._mv(0, 1);
  }

  /** Move head DOWN by `steps` places */
  mvDown(steps) {
    for (let i = 0; i < steps; i++) this._mv(0, -1);
  }

  toString(showVisited = false) {
    const rows = [];
    for (let y = this._max[1]; y >= this._min[1]; y--) {
      let row = "";
      for (let x = this._min[0]; x <= this._max[0]; x++) {
        let ri = this.rope.findIndex(([rx, ry]) => rx === x && ry === y);
        if (ri !== -1) row += ri === 0 ? "H" : ri.toString();
        else if (x === 0 && y === 0) row += "s";
        else if (showVisited && this.tail_visited.some(([vx, vy]) => x === vx && y === vy)) row += "#";
        else row += ".";
      }
      rows.push(row);
    }
    return rows.join("\n");
  }
}

module.exports = { Grid };