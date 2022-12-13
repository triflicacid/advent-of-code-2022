const fs = require("fs");

/** Return whether we (b) wins the round */
const win = (a, b) => (b == "X" && a == "C") || (b == "Y" && a == "A") || (b == "Z" && a == "B");

/** Check if a game is a draw */
const draw = (a, b) => (a == "A" && b == "X") || (a == "B" && b == "Y") || (a == "C" && b == "Z");

/** Get score for playing an item */
function item_score(a) {
  if (a == "A" || a == "X") return 1;
  if (a == "B" || a == "Y") return 2;
  if (a == "C" || a == "Z") return 3;
}

/** Return play requires to end the game in a certain way: X = lose, Y = draw, Z = win. */
function get_play(a, b) {
  if (b == "X") {
    if (a == "A") return "Z";
    else if (a == "B") return "X";
    else if (a == "C") return "Y";
  } else if (b == "Y") {
    if (a == "A") return "X";
    else if (a == "B") return "Y";
    else if (a == "C") return "Z";
  } else if (b == "Z") {
    if (a == "A") return "Y";
    else if (a == "B") return "Z";
    else if (a == "C") return "X";
  }
}

/** Get the game score */
function game_score(a, b) {
  if (draw(a, b)) return 3; // Draw
  if (win(a, b)) return 6; // We won
  return 0; // We lost
}

/** Get the total score of a game */
const total_score = (a, b) => item_score(b) + game_score(a, b);

(function () {
  const contents = fs.readFileSync("input.txt").toString();
  const plays = contents.split("\r\n").filter(x => x.length > 0).map(x => x.split(" "));
  const scores = plays.map(([p1, p2]) => total_score(p1, get_play(p1, p2)));
  console.log(scores.reduce((a, b) => a + b, 0));
})();