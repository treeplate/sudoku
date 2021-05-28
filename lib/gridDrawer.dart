import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sudoku/sevenSegmentDisplay.dart';

class GridDrawer extends StatelessWidget {
  const GridDrawer({
    Key? key,
    required this.values,
  }) : super(key: key);

  final List<List<int>> values;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GridPainter(values),
    );
  }
}

class GridPainter extends CustomPainter {
  GridPainter(this.values)
    : assert(math.sqrt(values.length) % 1 == 0),
      assert(math.sqrt(math.sqrt(values.length)) % 1 == 0);

  static final Paint thinLine = Paint()..style = PaintingStyle.stroke..color = Colors.black..strokeWidth = 1.0;
  static final Paint thickLine = Paint()..style = PaintingStyle.stroke..color = Colors.black..strokeWidth = 4.0;
  static final Paint redLine = Paint()..style = PaintingStyle.stroke..color = Colors.red;

  final List<List<int>> values;

  int get dim => math.sqrt(values.length).toInt();
  int get blockSize => math.sqrt(dim).toInt();

  @override
  bool shouldRepaint(GridPainter oldDelegate) {
    return values != oldDelegate.values;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double cellDim = size.shortestSide/dim;
    final double padding = cellDim / 10.0;
    for (int x = 0; x < dim + 1; x += 1) {
      canvas.drawLine(Offset(x * cellDim, 0), Offset(x * cellDim, cellDim * dim), x % blockSize == 0 ? thickLine : thinLine);
    }
    for (int y = 0; y < dim + 1; y += 1) {
      canvas.drawLine(Offset(0, y * cellDim), Offset(cellDim * dim, y * cellDim), y % blockSize == 0 ? thickLine : thinLine);
    }
    for (int y = 0; y < dim; y += 1) {
      for (int x = 0; x < dim; x += 1) {
        final List<int> centers = values[x + (y * dim)];
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
