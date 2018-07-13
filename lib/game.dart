import 'dart:math';

class Cell {

  int _number;
  bool _selected = false;

  get number => _number;
  get selected => _selected;

  Cell(this._number);

}

class Game {

  static const height = 5;
  static const width = 5;

  final _random = Random.secure();

  List<Cell> _cells;
  int _level = 5;
  int _moves = 6;
  int _score = 0;

  List<Cell> get cells => _cells;
  int get level => _level;
  int get moves => _moves;
  int get score => _score;

  bool get nextLevel => selected.any((c) => c._number == _level);
  List<Cell> get selected => _cells.where((c) => c._selected).toList();

  Game() {
    _cells = List.generate(height * width, (i) =>
      Cell(_random.nextInt(level) + 1)
    );
  }

  void toggle(int x, [int y = 0]) {
    final index = (y * width) + x;

    if (index >= _cells.length) {
      throw GameError("Coordinates out of range.");
    }

    _cells[index]._selected = !_cells[index]._selected;
  }

}

class GameError extends Error {

  final String message;

  GameError(this.message);

}
