function exec_op(a, op, b) {
  switch (op) {
    case '+': return a + b;
    case '-': return a - b;
    case '*': return a * b;
    case '/': return Math.floor(a / b);
  }
}

/** Create a monkey from a description */
function createMonkey(string) {
  string.shift(); // Remove "Monkey: ##" line

  // Items the monkey has. Array of worry levels.
  const items = string.shift().split(": ")[1].split(",").map(x => +x.trim());

  // How to calculate the new worry level
  const ops = string.shift().split(" = ")[1].split(" ");
  const op = x => exec_op((ops[0] === "old" ? x : +ops[0]), ops[1], (ops[2] === "old" ? x : +ops[2]));

  // Which monkey does ths current monkey throw said item to?
  const divisible = +string.shift().split(" ").pop();
  const ifTrue = +string.shift().split(" ").pop();
  const ifFalse = +string.shift().split(" ").pop();
  const pass = x => x % divisible === 0 ? ifTrue : ifFalse;

  return { items, op, divisible, pass, count: 0 };
}

/** Play a single round. Execute `itemTransform` after operation. */
function playRound(monkeys, itemTransform = undefined) {
  for (const monkey of monkeys) {
    // Loop through each item
    while (item = monkey.items.shift()) {
      monkey.count++;
      item = monkey.op(item); // Update worry level
      if (itemTransform) item = itemTransform(item);
      let to = monkey.pass(item); // Which monkey do we pass to?
      monkeys[to].items.push(item);
    }
  }
}

function monkeysToString(monkeys) {
  return monkeys.map((mk, i) => `Monkey ${i}: ` + mk.items.join(", ")).join("\n");
}

module.exports = { createMonkey, playRound, monkeysToString };