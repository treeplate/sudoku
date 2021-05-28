import 'package:flutter/material.dart';
import 'package:sudoku/sevenSegmentDisplay.dart';

class GridDrawer extends StatelessWidget {
  GridDrawer(this.grid, this.width);
  final List<int?> grid;
  final int width;
  int get height => grid.length ~/ width;
  Widget build(BuildContext context) {
    //print("DRW");
    return CustomPaint(
      painter: GridPainter(
        width,
        height,
        grid,
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  GridPainter(this.width, this.height, this.grid);
  final int width;
  final int height;
  final List<int?> grid;
  bool shouldRepaint(CustomPainter _) => true;
  void paint(Canvas canvas, Size size) {
    double cellDim = size.shortestSide/width;
    for (int y = 0; y < height; y += 1) {
      for (int x = 0; x < width; x += 1) {
        print("$x, ${x * cellDim}, $y, ${y * cellDim}, $cellDim");
        canvas.drawRect(Offset(x * cellDim, y * cellDim) & Size.square(cellDim), Paint()..style = PaintingStyle.stroke..color = Colors.black);
        drawNumber(canvas, x * cellDim + 50, y * cellDim + 50, cellDim-100, cellDim-100, grid[x + (y * width)]);
      }
    }
  }
}
