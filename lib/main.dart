import 'package:flutter/material.dart';
import 'package:sudoku/gridDrawer.dart';
import 'package:sudoku/logic.dart';

void main() {
  tests();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
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
  @override
  Widget build(BuildContext context) {
    return SudokuDrawer(grid);
  }
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
