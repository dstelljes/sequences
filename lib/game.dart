import 'dart:math';

typedef int Generator(int level);

class Game {

  List<GameCell> _cells;
  Generator _generator;
  int _height;
  int _level = 5;
  int _minimum;
  int _moves = 6;
  int _score = 0;
  int _width;

  List<GameCell> get cells => _cells;
  int get height => _height;
  int get level => _level;
  int get minimum => _minimum;
  int get moves => _moves;
  int get score => _score;
  int get width => _width;

  int get difference {
    if (selected.length == 0) {
      return null;
    }

    if (selected.length == 1) {
      return 0;
    }

    final numbers = selected.map((c) => c.number).toList()..sort();

    final differences = List.generate(
      max(0, numbers.length - 1),
      (i) => numbers[i + 1] - numbers[i]
    );

    return differences.every((d) => d == differences[0])
      ? differences[0]
      : null;
  }

  GamePreview get preview {
    if (difference == null || selected.length < _minimum) {
      return null;
    }

    final count = selected.length;
    final highest = selected.map((c) => c.number).reduce(max);
    final next = selected.any((c) => c.number == _level);

    return GamePreview(
      next ? 1 : 0,
      next ? sqrt(_level).floor() : -1,
      pow(difference, count) * highest
    );
  }

  List<GameCell> get selected => _cells.where((c) => c._selected).toList();

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
      (i) => GameCell(this._generator(this._level))
    );
  }

  void clear() {
    _cells.forEach((c) => c._selected = false);
  }

  void play() {
    final play = preview;

    if (play == null) {
      throw GameError("No valid sequence selected.");
    }

    _level += play.level;
    _moves += play.moves;
    _score += play.score;

    _cells = _cells.map((c) => c._selected ? GameCell(_generator(_level)) : c).toList();
  }

  void toggle(int x, int y) {
    if (x >= _width || y >= _height) {
      throw GameError("Coordinates out of range.");
    }

    final index = (y * _width) + x;
    _cells[index]._selected = !_cells[index]._selected;
  }

}

class GameCell {

  int _number;
  bool _selected = false;

  int get number => _number;
  bool get selected => _selected;

  GameCell(this._number);

}

class GameError extends Error {

  final String message;

  GameError(this.message);

}

class GamePreview {

  int _level;
  int _moves;
  int _score;

  int get level => _level;
  int get moves => _moves;
  int get score => _score;

  GamePreview(this._level, this._moves, this._score);

}
