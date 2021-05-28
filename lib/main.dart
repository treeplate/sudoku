import 'package:flutter/material.dart';
import 'package:sudoku/gridDrawer.dart';
import 'package:sudoku/logic.dart';

void main() {
  tests();
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({ Key? key }): super(key: key);

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
    return SudokuDrawer(grid: grid);
  }
}

class SudokuDrawer extends StatelessWidget {
  const SudokuDrawer({ Key? key, required this.grid }) : super(key: key);

  final SudokuGrid grid;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: GridDrawer(values: grid.values),
          ),
        ),
      ),
    );
  }
}
