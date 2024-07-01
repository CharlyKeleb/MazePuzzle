import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maze_puzzle/components/maze_painter.dart';

import 'package:maze_puzzle/models/cell_model.dart';
import 'package:maze_puzzle/models/enums/direction.dart';

class MazeHomePage extends StatefulWidget {
  const MazeHomePage({Key? key}) : super(key: key);

  @override
  State<MazeHomePage> createState() => _MazeHomePageState();
}

class _MazeHomePageState extends State<MazeHomePage>
    with SingleTickerProviderStateMixin {
  static const int _mazeWidth = 10;
  static const int _mazeHeight = 10;
  static const double _cellSize = 40.0;

  late List<List<Cell>> _grid;
  late AnimationController _controller;
  late Animation<double> _animation;
  final Random _random = Random();

  int _playerX = 0;
  int _playerY = 0;

  @override
  void initState() {
    super.initState();
    _initializeGrid();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  void _initializeGrid() {
    // Initialize the grid with cells
    _grid = List.generate(
      _mazeHeight,
      (y) => List.generate(_mazeWidth, (x) => Cell(x, y)),
    );
    // Generate the maze starting from the top-left corner
    _generateMaze(0, 0);
  }

  void _generateMaze(int startX, int startY) {
    _visitCell(startX, startY);
  }

  void _visitCell(int x, int y) {
    // Mark the current cell as visited
    _grid[y][x].visited = true;
    var directions = _shuffleDirections();

    // Visit neighboring cells in random order
    for (var direction in directions) {
      var nx = x + direction.dx;
      var ny = y + direction.dy;

      if (_isInside(nx, ny) && !_grid[ny][nx].visited) {
        _grid[y][x].removeWall(direction);
        _grid[ny][nx].removeWall(direction.opposite);
        _visitCell(nx, ny);
      }
    }
  }

  List<Direction> _shuffleDirections() {
    // Shuffle the directions (up, down, left, right)
    var directions = Direction.values.toList();
    directions.shuffle(_random);
    return directions;
  }

  bool _isInside(int x, int y) {
    // Check if the coordinates are within the maze boundaries
    return x >= 0 && x < _mazeWidth && y >= 0 && y < _mazeHeight;
  }

  void _generateNewMaze() {
    // Reset animation and regenerate the maze
    _controller.reset();
    _initializeGrid();
    _controller.forward();
    setState(() {
      _playerX = 0;
      _playerY = 0;
    });
  }

  void _movePlayer(Direction direction) {
    var newX = _playerX + direction.dx;
    var newY = _playerY + direction.dy;

    if (_isInside(newX, newY)) {
      var currentCell = _grid[_playerY][_playerX];
      var targetCell = _grid[newY][newX];

      if (!currentCell.hasWall(direction)) {
        // Move the player if the target cell has no wall in the direction
        setState(() {
          _playerX = newX;
          _playerY = newY;
        });

        // Check if the player has reached the bottom-right corner
        if (_playerX == _mazeWidth - 1 && _playerY == _mazeHeight - 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You have solved the maze!')),
          );
          _generateNewMaze();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maze Generator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Maze grid and player indicator
            Stack(
              children: [
                CustomPaint(
                  size: const Size(
                    _mazeWidth * _cellSize,
                    _mazeHeight * _cellSize,
                  ),
                  painter: MazePainter(_grid, _animation.value),
                ),
                Positioned(
                  left: _playerX * _cellSize,
                  top: _playerY * _cellSize,
                  child: Container(
                    width: _cellSize,
                    height: _cellSize,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/web.png'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Control buttons for player movement
            _buildControlButtons(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateNewMaze,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  // Widget for rendering control buttons (arrows)
  Widget _buildControlButtons() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _movePlayer(Direction.up),
          child: Image.asset(
            'assets/images/up-arrow.png',
            height: 50.0,
            width: 50.0,
            color: Colors.white54,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _movePlayer(Direction.left),
              child: Image.asset(
                'assets/images/left-arrow.png',
                height: 50.0,
                width: 50.0,
                color: Colors.white54,
              ),
            ),
            const SizedBox(width: 70.0),
            GestureDetector(
              onTap: () => _movePlayer(Direction.right),
              child: Image.asset(
                'assets/images/right-arrow.png',
                height: 50.0,
                width: 50.0,
                color: Colors.white54,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        GestureDetector(
          onTap: () => _movePlayer(Direction.down),
          child: Image.asset(
            'assets/images/down-arrow.png',
            height: 50.0,
            width: 50.0,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

extension on Direction {
  Direction get opposite {
    switch (this) {
      case Direction.up:
        return Direction.down;
      case Direction.down:
        return Direction.up;
      case Direction.left:
        return Direction.right;
      case Direction.right:
        return Direction.left;
    }
  }

  int get dx {
    switch (this) {
      case Direction.left:
        return -1;
      case Direction.right:
        return 1;
      default:
        return 0;
    }
  }

  int get dy {
    switch (this) {
      case Direction.up:
        return -1;
      case Direction.down:
        return 1;
      default:
        return 0;
    }
  }
}
