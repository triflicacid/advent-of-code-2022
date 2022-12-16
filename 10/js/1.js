const fs = require('fs');
const { create_record, create_cpu } = require("./CPULib");

(function () {
  const contents = fs.readFileSync("../inputSample2.txt").toString();

  const ops = contents.split("\r\n").filter(x => x.length > 0).map(x => x.split(" "));

  const cpu = create_cpu(),
    rec = create_record(20, 40);
  cpu.setRecord(rec);
  ops.forEach(op => {
    cpu.exec(op[0], op.slice(1));
  });
  console.log(`x = ${cpu.getX()} after ${cpu.getCycle()} cycles`);
  const signals = rec.get().map(([x, cy]) => x * cy);
  console.log("Sum of recorded signals: " + signals.reduce((a, s) => a + s, 0));
})();