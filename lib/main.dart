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

class ToggleDigitIntent extends Intent {
  const ToggleDigitIntent(this.digit);
  final int digit;
}

class _MyAppState extends State<MyApp> {
  SudokuGrid grid = SudokuGrid.fromStrings([
    "1...",
    ".2..",
    ".14.",
    "..2.",
  ]);

  int selected = 0;
  String lastStepReasoning = "";

  void _toggle(int digit) {
    setState(() {
      var deduction = grid.toggleCenter(selected, digit);
      grid = deduction.result;
      lastStepReasoning = deduction.reasoning;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        CharacterActivator('1'): ToggleDigitIntent(1),
        CharacterActivator('2'): ToggleDigitIntent(2),
        CharacterActivator('3'): ToggleDigitIntent(3),
        CharacterActivator('4'): ToggleDigitIntent(4),
        CharacterActivator('5'): ToggleDigitIntent(5),
        CharacterActivator('6'): ToggleDigitIntent(6),
        CharacterActivator('7'): ToggleDigitIntent(7),
        CharacterActivator('8'): ToggleDigitIntent(8),
        CharacterActivator('9'): ToggleDigitIntent(9),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          ToggleDigitIntent: CallbackAction<ToggleDigitIntent>(
              onInvoke: (ToggleDigitIntent intent) => _toggle(intent.digit)),
        },
        child: Focus(
          autofocus: true,
          child: Column(
            children: [
              Material(
                  child: Text(
                      "Solved (correctly): ${grid.verify()}\n\nLast step: $lastStepReasoning")),
              TextButton(
                child: const Text("Do next step"),
                onPressed: () {
                  setState(() {
                    Deduction deduction = grid.nextStep();
                    grid = deduction.result;
                    lastStepReasoning = deduction.reasoning;
                  });
                },
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return GestureDetector(
                      child: SudokuDrawer(grid: grid, selected: selected),
                      onTapDown: (TapDownDetails details) {
                        setState(() {
                          double padding = (constraints.biggest.longestSide -
                                  constraints.biggest.shortestSide) /
                              2;
                          Offset offsetPadding =
                              constraints.biggest.longestSide ==
                                      constraints.maxWidth
                                  ? Offset(padding, 0)
                                  : Offset(0, padding);
                          var pixelsPerGridCell =
                              (constraints.biggest.shortestSide / grid.dim);
                          Offset gridOffset =
                              (details.localPosition - offsetPadding) /
                                  pixelsPerGridCell;
                          selected = (gridOffset.dy.truncate() * grid.dim +
                              gridOffset.dx.truncate());
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
