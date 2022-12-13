/** Get ordinal value of an item */
function get_val(char) {
  let ascii = char.charCodeAt(0);
  let val = ascii - (ascii <= 90 ? 64 - 26 : 96);
  return val;
}

module.exports = { get_val };