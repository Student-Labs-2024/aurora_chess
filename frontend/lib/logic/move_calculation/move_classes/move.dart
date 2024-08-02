import "../../../exports.dart";

class Move {
  int from;
  int to;
  ChessPieceType promotionType;

  Move(this.from, this.to, {this.promotionType = ChessPieceType.promotion});

  @override
  bool operator ==(move) =>
      this.from == (move as Move).from && (this as Move).to == move.to;
  @override
  int get hashCode => super.hashCode;
}
