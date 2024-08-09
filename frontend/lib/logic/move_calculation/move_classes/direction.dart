class Direction {
  final int up;
  final int right;

  const Direction(this.up, this.right);
}

const up = Direction(1, 0);
const upRight = Direction(1, 1);
const right = Direction(0, 1);
const downRight = Direction(-1, 1);
const down = Direction(-1, 0);
const downLeft = Direction(-1, -1);
const left = Direction(0, -1);
const upLeft = Direction(1, -1);
