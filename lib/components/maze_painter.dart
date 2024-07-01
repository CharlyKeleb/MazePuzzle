
// Custom painter for drawing the maze grid
import 'package:flutter/material.dart';
import 'package:maze_puzzle/models/cell_model.dart';

class MazePainter extends CustomPainter {
  final List<List<Cell>> grid;
  final double progress;

  MazePainter(this.grid, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white24.withOpacity(0.8)
      ..strokeWidth = 7
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, convertRadiusToSigma(1));

    final cellWidth = size.width / grid[0].length;
    final cellHeight = size.height / grid.length;

    // Draw walls of each cell in the grid
    for (int y = 0; y < grid.length; y++) {
      for (int x = 0; x < grid[y].length; x++) {
        final cell = grid[y][x];
        final left = x * cellWidth;
        final top = y * cellHeight;

        if (cell.topWall) {
          canvas.drawLine(
            Offset(left, top),
            Offset(left + cellWidth, top),
            paint,
          );
        }
        if (cell.leftWall) {
          canvas.drawLine(
            Offset(left, top),
            Offset(left, top + cellHeight),
            paint,
          );
        }
        if (cell.rightWall) {
          canvas.drawLine(
            Offset(left + cellWidth, top),
            Offset(left + cellWidth, top + cellHeight),
            paint,
          );
        }
        if (cell.bottomWall) {
          canvas.drawLine(
            Offset(left, top + cellHeight),
            Offset(left + cellWidth, top + cellHeight),
            paint,
          );
        }
      }
    }
  }

  static double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}