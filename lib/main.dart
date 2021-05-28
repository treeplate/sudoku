import 'package:flutter/material.dart';
import 'package:sudoku/gridDrawer.dart';
import 'package:sudoku/logic.dart';

SudokuGrid grid = SudokuGrid.fromStrings([
  "1.3.",
  ".2..",
  "..43",
  "..2.",
]);

void main() {
  tests();
  runApp(MaterialApp(home: SudokuDrawer(grid)));
}

class SudokuDrawer extends StatelessWidget {
  final SudokuGrid grid;
  const SudokuDrawer(this.grid);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GridDrawer(grid.values, grid.dim),
    );
  }
}
