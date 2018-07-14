import 'dart:math';

class Cell {

  int _number;
  bool _selected = false;

  get number => _number;
  get selected => _selected;

  Cell(this._number);

}

class Game {

  int _height;
  int _width;

  List<Cell> _cells;
  Generator _generator;
  int _level = 5;
  int _moves = 6;
  int _score = 0;

  List<Cell> get cells => _cells;
  int get level => _level;
  int get moves => _moves;
  int get score => _score;

  bool get nextLevel => selected.any((c) => c._number == _level);

  List<Cell> get selected => _cells.where((c) => c._selected).toList();

  Game([this._height = 5, this._width = 5, generator]) {
    if (generator == null) {
      final random = Random.secure();
      generator = (level) => random.nextInt(level) + 1;
    }

    this._generator = generator;

    _cells = List.generate(
      _height * _width,
      (i) => Cell(this._generator(this._level))
    );
  }

  void toggle(int x, [int y = 0]) {
    final index = (y * _width) + x;

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

typedef int Generator(int index);
