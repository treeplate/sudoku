import 'package:flutter/material.dart';
import 'package:sudoku/gridDrawer.dart';
import 'package:sudoku/logic.dart';

void main() {
  tests();
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SudokuGrid grid = SudokuGrid.fromStrings([
    "1.3.",
    ".2..",
    "..43",
    "..2.",
  ]);
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return GestureDetector(
        child: SudokuDrawer(grid: grid, selected: selected),
        onTapDown: (TapDownDetails details) {
          setState(() {
            double padding = (constraints.biggest.longestSide -
                constraints.biggest.shortestSide) / 2;
            Offset offsetPadding =
                constraints.biggest.longestSide == constraints.maxWidth
                    ? Offset(padding, 0)
                    : Offset(0, padding);
            var pixelsPerGridCell = (constraints.biggest.shortestSide / grid.dim);
                        Offset gridOffset = (details.localPosition - offsetPadding) /
                            pixelsPerGridCell;
            selected = (gridOffset.dy.truncate() * grid.dim +
                gridOffset.dx.truncate());
          });
        },
      );
    });
  }
}

class SudokuDrawer extends StatelessWidget {
  const SudokuDrawer({Key? key, required this.grid, required this.selected})
      : super(key: key);

  final SudokuGrid grid;
  final int selected;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: GridDrawer(values: grid.values, selected: selected),
          ),
        ),
      ),
    );
  }
}
