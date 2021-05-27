import 'package:flutter/material.dart';
import 'package:sudoku/logic.dart';

void main() {
  tests();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Text("${SudokuGrid.fromStrings(["1.3.",".2..", "....", "...."]).allowed(3, 0)}"),
     );
  }
}
