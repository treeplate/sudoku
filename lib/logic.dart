import 'dart:math';

import 'package:flutter/foundation.dart' show setEquals;

bool listEquals(List a, List b) {
  if(a.length != b.length) return false;
  for(int i = 0; i < a.length; i++) {
    if(a[i].runtimeType != b[i].runtimeType) return false;
    if(a[i] is List && !listEquals(a[i], b[i])) return false;
  }
  return true;
}

class SudokuGrid {
  SudokuGrid(this.values) :
    assert(sqrt(values.length) % 1 == 0),
    assert(sqrt(sqrt(values.length)) % 1 == 0);

  final List<List<int>> values;

  int get dim => sqrt(values.length).toInt();
  int get blockSize => sqrt(dim).toInt();

  List<List<int>> row(int n) {
    return values.sublist(n * dim, (n + 1) * dim);
  }

  Iterable<List<int>> column(int n) sync* {
    for (int index = 0; index < dim; index++) {
      yield values[n + index * dim];
    }
  }

  List<List<int>> block(int blx, int bly) {
    List<List<int>> squares = [];
    int fullX = blx * blockSize;
    int fullY = bly * blockSize;
    for (int y = fullY; y < fullY + blockSize; y++) {
      for (int x = fullX; x < fullX + blockSize; x++) {
        squares.add(position(x, y));
      }
    }
    return squares.toList();
  }

  List<int> position(int x, int y) => values[x + y * dim];

  Set<int> setOfPos(int x, int y) => {position(x, y).single};

  Set<int> allowed(int x, int y) {
    Set<int> result = List.generate(dim, (index) => index + 1).toSet();
    result.removeAll((row(y)..remove(position(x, y))).map((List<int> centers) => centers.length == 1 ? centers.single : []));
    result.removeAll((column(x).toList()..remove(position(x, y))).map((List<int> centers) => centers.length == 1 ? centers.single : []));
    result.removeAll((block(x ~/ blockSize, y ~/ blockSize)..remove(position(x, y))).map((List<int> centers) => centers.length == 1 ? centers.single : []));
    return result;
  }

  Set<int> verifySet(int x, int y) {
    SudokuGrid grid = fill(x, y, List.generate(dim, (index) => index + 1));
    return grid.allowed(x, y);
  }

  bool verify() {
    for (int y = 0; y < dim; y++) {
      for (int x = 0; x < dim; x++) {
        try {
          if (!setEquals(allowed(x, y), {position(x, y).single})) return false;
        } on StateError {
          return false;
        }
      }
    }
    return true;
  }

  SudokuGrid fill(int x, int y, List<int> cell) {
    List<List<int>> temp = values.toList();
    temp[x + y * dim] = cell;
    return SudokuGrid(temp.toList());
  }
  
  Deduction removeCenter(int x, int y, int center) {
    String reasoning = "";
    if(row(y).where((element) => element.length == 1).map((e) => e.single).contains(center)) reasoning = "row contains $center";
    else if(column(x).where((element) => element.length == 1).map((e) => e.single).contains(center)) reasoning = "column contains $center";
    else if(block(x ~/ blockSize, y ~/ blockSize).where((element) => element.length == 1).map((e) => e.single).contains(center)) reasoning = "box contains $center";
    return Deduction(fill(x, y, position(x, y).toList()..remove(center)), reasoning);
  }
  SudokuGrid addCenter(int x, int y, int center) {
    return fill(x, y, position(x, y).toList()..add(center));
  }

  static SudokuGrid fromStrings(List<String> rows) {
    List<List<int>> list = [];
    for (String row in rows) {
      for (String char in row.split('')) {
        if (char == ".") {
          list.add(List.generate(rows.length, (index) => index + 1));
        } else {
          list.add([int.parse(char)]);
        }
      }
    }
    return SudokuGrid(list.toList());
  }
}

void tests() {
  var grid = SudokuGrid([
      [0],   [1],  [2],  [3],
      [10], [11], [12], [13],
      [20], [21], [22], [23],
      [30], [31], [32], [33],
  ]);
  assert(listEquals(grid.row(1), [[10], [11], [12], [13]]));
  assert(listEquals(grid.column(1).toList(), [[1], [11], [21], [31]]));
  assert(listEquals(grid.position(1, 1), [11]));
  assert(listEquals(grid.block(1, 0), [[2], [3], [12], [13]]));

  var badGrid1 = SudokuGrid.fromStrings([
    ".123",
    ".123",
    ".123",
    ".123"
  ]);
  assert(!badGrid1.verify());


  var badGrid2 = SudokuGrid.fromStrings([
    "1234",
    "2341",
    "3412",
    "4123"
  ]);
  assert(!badGrid2.verify());

  var sparseGrid = SudokuGrid.fromStrings([
    "1.3.",
    ".2..",
    "4...",
    "...4"
  ]);
  assert(setEquals(sparseGrid.allowed(0, 0), {1}));
  assert(setEquals(sparseGrid.allowed(1, 0), {4}));
  assert(sparseGrid.allowed(3, 1).single == 1);
  assert(setEquals(sparseGrid.allowed(2, 3), {1, 2}));
}

class Deduction {
  Deduction(this.result, this.reasoning);
  final SudokuGrid result;
  final String reasoning;
}