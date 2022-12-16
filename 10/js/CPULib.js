function create_record(start, step) {
  const record = [];
  return {
    getStart: () => start,
    setStart: st => (start = st),
    getStep: () => step,
    setStep: st => (step = st),
    get: () => [...record],
    len: () => record.length,
    getAt: i => record[i],
    reset: () => void (record.length = 0),
    record: (val, cycle) => (cycle - start) % step === 0 && (record.push(val) || true),
  };
}

function create_cpu() {
  let x = 1, cycle = 0;
  let record, crt;

  function callPeripherals() {
    if (record) record.record([x, cycle], cycle);
    if (crt) crt.draw(x);
  }

  return {
    getX: () => x,
    getCycle: () => cycle,
    reset: () => {
      x = 1;
      cycle = 0;
    },
    exec: (instruct, args) => {
      switch (instruct) {
        case "noop":
          cycle++;
          callPeripherals();
          break;
        case "addx":
          cycle++;
          callPeripherals();
          cycle++;
          callPeripherals();
          x += +args[0];
          break;
      }
    },
    // Peripherals
    getRecord: () => record,
    setRecord: r => (record = r),
    getCRT: () => crt,
    setCRT: c => (crt = c),
  };
}

function create_crt(width, spriteWidth = 3) {
  let output = "", calls = 0, cpos = 0;
  let sp = (spriteWidth - 1) / 2;
  return {
    getWidth: () => width,
    getCalls: () => calls,
    getSpriteWidth: () => spriteWidth,
    setSpriteWidth: sw => {
      spriteWidth = sw;
      sp = (sw - 1) / 2;
      return sw;
    },
    get: () => output,
    reset: () => {
      output = "";
      calls = 0;
    },
    draw: (hpos) => {
      calls++;
      output += (cpos >= hpos - sp && cpos <= hpos + sp) ? "#" : ".";
      cpos++;
      if (calls % width === 0) {
        output += "\n";
        cpos = 0;
      }
    }
  };
}

module.exports = { create_record, create_cpu, create_crt };