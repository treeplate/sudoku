import 'package:flutter/material.dart';
import 'package:sudoku/sevenSegmentDisplay.dart';

class GridDrawer extends StatelessWidget {
  const GridDrawer(this.grid, this.width, {Key? key}): super(key: key);
  final List<List<int>> grid;
  final int width;
  int get height => grid.length ~/ width;
  @override
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
  final List<List<int>> grid;

  @override
  bool shouldRepaint(GridPainter old) {
    return width != old.width
        || height != old.height
        || grid != old.grid;
  }

  static final Paint blackLine = Paint()..style = PaintingStyle.stroke..color = Colors.black;
  static final Paint redLine = Paint()..style = PaintingStyle.stroke..color = Colors.red;

  @override
  void paint(Canvas canvas, Size size) {
    final double cellDim = size.shortestSide/width;
    final double padding = cellDim / 10.0;
    for (int y = 0; y < height; y += 1) {
      for (int x = 0; x < width; x += 1) {
        canvas.drawRect(Offset(x * cellDim, y * cellDim) & Size.square(cellDim), blackLine);
        final List<int> centers = grid[x + (y * width)];
        if (centers.isNotEmpty) {
          final double digitPadding = centers.length > 1 ? padding / (centers.length - 1) : 0.0;
          final double digitWidth = (cellDim - padding * 2.0) / centers.length;
          final double digitY = (y + 0.5) * cellDim - digitWidth / 2.0;
          double digitX = x * cellDim + padding;
          for (int digit in centers) {
            drawNumber(canvas, digitX + digitPadding, digitY, digitWidth - digitPadding * 2.0, digitWidth, digit);
            digitX += digitWidth;
          }
        } else {
          canvas.drawCircle(Offset((x + 0.5) * cellDim, (y + 0.5) * cellDim), cellDim / 4.0, redLine);
        }
      }
    }
  }
}
