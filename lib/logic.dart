import 'dart:math';

class SudokuGrid {
  SudokuGrid(this.values) {
    assert(sqrt(values.length) == 0);
    assert(sqrt(sqrt(values.length)) == 0.0);
  }
  final List<int?> values;
  int get dim => sqrt(values.length).toInt();
  int get blockSize => sqrt(dim).toInt();

  List<int?> row(int n) {
    return values.sublist(n * dim, (n + 1) * dim);
  }

  Iterable<int?> column(int n) sync* {
    for (int index = 0; index < dim; index++) {
      yield values[n + index * dim];
    }
  }

  List<int?> block(int blx, int bly) {
    List<int?> squares = [];
    int fullX = blx * blockSize;
    int fullY = bly * blockSize;
    for (int y = fullY; y < fullY + blockSize; y++) {
      for (int x = fullX; x < fullX + blockSize; x++) {
        squares.add(position(x, y));
      }
    }
    return squares.toList();
  }

  int? position(int x, int y) => values[x + y * dim];

  Set<int> setOfPos(int x, int y) => {position(x, y)!};

  Set<int> allowed(int x, int y, [Set<int> Function(int x, int y)? ifFilled]) {
    if (position(x, y) != null) {
      return (ifFilled ?? setOfPos)(x, y);
    }
    Set<int> result = List.generate(dim, (index) => index + 1).toSet();
    result.removeAll(row(y).whereType<int>());
    result.removeAll(column(x).whereType<int>());
    result.removeAll(block(x ~/ blockSize, y ~/ blockSize).whereType<int>());
    return result;
  }

  Set<int> verifySet(int x, int y) {
    SudokuGrid grid = fill(x, y, null);
    Set<int> result = List.generate(dim, (index) => index + 1).toSet();
    result.removeAll(grid.row(y).whereType<int>());
    result.removeAll(grid.column(x).whereType<int>());
    result
        .removeAll(grid.block(x ~/ blockSize, y ~/ blockSize).whereType<int>());
    return result;
  }

  bool verify() {
    for (int y = 0; y < dim; y++) {
      for (int x = 0; x < dim; x++) {
        if (allowed(x, y, verifySet).single != position(x, y)) return false;
      }
    }
    return true;
  }

  void printToConsole() {
    for (int y = 0; y < dim; y++) {
      print(row(y).map((int? it) {
        if (it == null)
          return ".";
        else
          return it.toString();
      }).join(""));
    }
  }

  SudokuGrid fill(int x, int y, int? cell) {
    List<int?> temp = values.toList();
    temp[x + y * dim] = cell;
    return SudokuGrid(temp.toList());
  }

  static SudokuGrid fromStrings(List<String> rows) {
    List<int?> list = [];
    for (String row in rows) {
      for (String char in row.split('')) {
        if (char == ".") {
          list.add(null);
        } else {
          list.add(int.parse(char));
        }
      }
    }
    return SudokuGrid(list.toList());
  }
}
