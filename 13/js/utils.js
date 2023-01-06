/** Extract between matching brackets. string[startIndex] must be <open>. Return index of matching <close> */
function matchBrackets(string, open = '[', close = ']', startIndex = 0) {
  let count = 0;
  for (let i = startIndex; i < string.length; i++) {
    if (string[i] === open) count++;
    else if (string[i] === close) count--;
    if (count <= 0) return i;
  }
  return -1;
}

/** Have we got a number? */
const isNum = n => !isNaN(+n);

/** Split list of items into list */
function split(string) {
  if (string[0] === '[') string = string.substring(1, string.length - 1); // Remove brackets
  const list = [];
  for (let i = 0; i < string.length;) {
    if (isNum(string[i])) {
      let num = "";
      while (isNum(string[i])) num += string[i++];
      list.push(num);
    } else if (string[i] === "[") {
      let end = i + matchBrackets(string.substring(i));
      list.push(string.substring(i, end + 1));
      i = end + 1;
    } else {
      i += 1;
    }
  }
  return list;
}

/** Compare two input lists. Are they in the correct order?. Return true, false, or null if equal */
function compare(lhs, rhs) {
  if (isNum(lhs) && isNum(rhs)) {
    if (+lhs === +rhs) return null;
    return +lhs < +rhs;
  }
  if (isNum(lhs) && !isNum(rhs)) lhs = "[" + lhs + "]";
  if (!isNum(lhs) && isNum(rhs)) rhs = "[" + rhs + "]";
  // Both lists... iterate through them
  const left = split(lhs), right = split(rhs), max = Math.max(left.length, right.length);
  // console.log(left, right)
  for (let i = 0; i < max; i++) {
    if (left[i] === undefined) return true; // If LHS runs out, in correct order
    if (right[i] === undefined) return false; // If RHS runs out, not in correct order
    const cmp = compare(left[i], right[i]);
    if (cmp === null) continue;
    return cmp;
  }
  return null;
}

module.exports = { compare };