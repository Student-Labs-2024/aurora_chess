import "../../../exports.dart";

class Move {
  int from;
  int to;
  ChessPieceType promotionType;

  Move(this.from, this.to, {this.promotionType = ChessPieceType.promotion});

  @override
  bool operator == (other) =>
      from == (other as Move).from && (this).to == other.to;

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;




}
