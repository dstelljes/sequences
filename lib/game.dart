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
  int _minimum;
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

  bool get canHoof {
    if (selected.length < _minimum) {
      return false;
    }

    final numbers = selected.map((c) => c.number).toList();
    numbers.sort();

    final differences = List.generate(
      max(0, numbers.length - 1),
      (i) => numbers[i + 1] - numbers[i]
    );

    return differences.every((d) => d == differences[0]);
  }

  bool get nextLevel => selected.any((c) => c._number == _level);

  List<Cell> get selected => _cells.where((c) => c._selected).toList();

  Game({ int width = 5, int height = 5, int minimum = 3, Generator generator }) {
    if (generator == null) {
      final random = Random.secure();
      generator = (level) => random.nextInt(level) + 1;
    }

    this._generator = generator;
    this._height = height;
    this._minimum = minimum;
    this._width = width;

    _cells = List.generate(
      _height * _width,
      (i) => Cell(this._generator(this._level))
    );
  }

  void toggle(int x, int y) {
    if (x >= _width || y >= _height) {
      throw GameError("Coordinates out of range.");
    }

    final index = (y * _width) + x;
    _cells[index]._selected = !_cells[index]._selected;
  }

}

class GameError extends Error {

  final String message;

  GameError(this.message);

}

typedef int Generator(int level);
