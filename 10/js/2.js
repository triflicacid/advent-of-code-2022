const fs = require('fs');
const { create_cpu, create_crt } = require("./CPULib");

(function () {
  const contents = fs.readFileSync("../input.txt").toString();

  const ops = contents.split("\r\n").filter(x => x.length > 0).map(x => x.split(" "));

  const cpu = create_cpu(),
    crt = create_crt(40, 3);
  cpu.setCRT(crt);

  ops.forEach(op => cpu.exec(op[0], op.slice(1)));

  console.log(`x = ${cpu.getX()} after ${cpu.getCycle()} cycles`);
  console.log("===== [ CRT ] =====");
  console.log(crt.get());
})();