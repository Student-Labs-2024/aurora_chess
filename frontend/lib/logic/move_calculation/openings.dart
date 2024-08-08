import "../../exports.dart";

var openings = [
  [
    Move(tileToInt("e2"), tileToInt("e4")),
    Move(tileToInt("e7"), tileToInt("e5")),
    Move(tileToInt("g1"), tileToInt("f3")),
    Move(tileToInt("b8"), tileToInt("c6")),
    Move(tileToInt("f1"), tileToInt("b5")),
  ],
  [
    Move(tileToInt("e2"), tileToInt("e4")),
    Move(tileToInt("e7"), tileToInt("e5")),
    Move(tileToInt("g1"), tileToInt("f3")),
    Move(tileToInt("b8"), tileToInt("c6")),
    Move(tileToInt("f1"), tileToInt("c4"))
  ],
  [
    Move(tileToInt("e2"), tileToInt("e4")),
    Move(tileToInt("c7"), tileToInt("c5")),
  ],
  [
    Move(tileToInt("e2"), tileToInt("e4")),
    Move(tileToInt("e7"), tileToInt("e6")),
  ],
  [
    Move(tileToInt("e2"), tileToInt("e4")),
    Move(tileToInt("c7"), tileToInt("c6")),
  ],
  [
    Move(tileToInt("e2"), tileToInt("e4")),
    Move(tileToInt("d7"), tileToInt("d6")),
  ],
  [
    Move(tileToInt("d2"), tileToInt("d4")),
    Move(tileToInt("d7"), tileToInt("d5")),
    Move(tileToInt("c2"), tileToInt("c4")),
  ],
  [
    Move(tileToInt("d2"), tileToInt("d4")),
    Move(tileToInt("g8"), tileToInt("f6")),
  ],
  [
    Move(tileToInt("c2"), tileToInt("c4")),
  ],
  [
    Move(tileToInt("g1"), tileToInt("f3")),
  ]
];

int tileToInt(String tile) {
  var file = tile.codeUnitAt(0) - LogicConsts.baseChar;
  var rank = LogicConsts.lenOfRow - (int.tryParse(tile[1]) ?? 0);
  return rank * LogicConsts.lenOfRow + file;
}