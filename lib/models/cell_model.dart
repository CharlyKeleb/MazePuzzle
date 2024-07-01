import 'package:maze_puzzle/models/enums/direction.dart';

// Class representing a cell in the maze grid
class Cell {
  final int x, y;
  bool visited = false;
  bool topWall = true;
  bool bottomWall = true;
  bool leftWall = true;
  bool rightWall = true;

  Cell(this.x, this.y);

  void removeWall(Direction direction) {
    // Remove wall in the specified direction
    switch (direction) {
      case Direction.up:
        topWall = false;
        break;
      case Direction.down:
        bottomWall = false;
        break;
      case Direction.left:
        leftWall = false;
        break;
      case Direction.right:
        rightWall = false;
        break;
    }
  }

  bool hasWall(Direction direction) {
    // Check if the cell has a wall in the specified direction
    switch (direction) {
      case Direction.up:
        return topWall;
      case Direction.down:
        return bottomWall;
      case Direction.left:
        return leftWall;
      case Direction.right:
        return rightWall;
    }
  }
}
