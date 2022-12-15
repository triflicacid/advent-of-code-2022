class Entity {
  constructor(name) {
    this.name = name;
  }

  getSize() {
    throw new Error("getSize: requires implementation.");
  }

  toString(indent = 0) {
    return "  ".repeat(indent) + this.name.toString();
  }
}

class File extends Entity {
  constructor(name, size) {
    super(name);
    this.size = size;
  }

  getSize() {
    return this.size;
  }

  toString(indent = 0) {
    return "  ".repeat(indent) + `- ${this.name} (file, size=${this.size})`;
  }
}

class Directory extends Entity {
  constructor(name, parent) {
    super(name);
    this.parent = parent;
    this.children = [];
    this.path = (parent ? parent.path + name + "/" : name);
  }

  addChild(item) {
    this.children.push(item);
  }

  getSize() {
    return this.children.map(ch => ch.getSize()).reduce((a, b) => a + b, 0);
  }

  openDir(name) {
    return this.children.find(c => c instanceof Directory && c.name === name);
  }

  toString(indent = 0) {
    return "  ".repeat(indent) + `- ${this.name} (dir, size=${this.getSize()})\n` + this.children.map(ch => ch.toString(indent + 1)).join("\n");
  }

  /** Given a bash script, populate children (assume this is root) */
  populateFromScript(script) {
    let cwd = this, in_ls = false;
    script.split("\r\n").filter(x => x.length > 0).forEach(line => {
      let stuff = line.split(" ");
      if (stuff[0] == "$") {
        in_ls = false;
        if (stuff[1] === "cd") {
          if (cwd === this && stuff[2] === this.name) {
            // Pass
          } else if (stuff[2] === "..") {
            cwd = cwd.parent;
          } else {
            cwd = cwd.openDir(stuff[2]);
          }
        } else if (stuff[1] === "ls") {
          in_ls = true;
        } else {
          throw new Error(`Script: Unknown command '${stuff[1]}'`);
        }
      }

      else if (in_ls) {
        if (stuff[0] === "dir") {
          let dir = new Directory(stuff[1], cwd);
          cwd.addChild(dir);
        } else {
          let file = new File(stuff[1], +stuff[0]);
          cwd.addChild(file);
        }
      } else {
        throw new Error(`Script: Error: '${stuff[0]}'`);
      }
    });
  };
}

module.exports = { File, Directory };