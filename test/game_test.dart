import 'package:flutter_test/flutter_test.dart';
import 'package:sequences/game.dart';

void main() {
  group('initial state', () {
    test('with 0x0 board', () {
      final game = Game(width: 0, height: 0);

      expect(game.cells, hasLength(0));
      expect(game.score, equals(0));
      expect(game.selected, isEmpty);
    });

    test('with 2x2 board', () {
      final game = Game(width: 2, height: 2);
      expect(game.cells, hasLength(4));
    });
  });

  group('cell', () {
    test('selection and deselection', () {
      final game = Game(width: 1, height: 1);

      expect(game.selected, hasLength(0));
      game.toggle(0, 0);
      expect(game.selected, hasLength(1));
      game.toggle(0, 0);
      expect(game.selected, hasLength(0));
    });

    test('counting', () {
      final game = Game(width: 3, height: 3);

      expect(game.selected, hasLength(0));
      game.toggle(0, 0);
      expect(game.selected, hasLength(1));
      game.toggle(0, 0);
      expect(game.selected, hasLength(0));
      game.toggle(0, 1);
      expect(game.selected, hasLength(1));
      game.toggle(1, 0);
      expect(game.selected, hasLength(2));
      game.toggle(0, 2);
      expect(game.selected, hasLength(3));
      game.toggle(1, 0);
      expect(game.selected, hasLength(2));
    });

    test('clearing', () {
      final game = Game(width: 2, height: 2);

      expect(game.selected, hasLength(0));
      game.toggle(1, 1);
      expect(game.selected, hasLength(1));
      game.toggle(0, 1);
      expect(game.selected, hasLength(2));
      game.clear();
      expect(game.selected, hasLength(0));
    });

    test('out-of-range errors', () {
      final game = Game(width: 3, height: 3);
      
      expect(
        () => game.toggle(0, 3),
        throwsA(new isInstanceOf<GameError>())
      );

      expect(
        () => game.toggle(3, 0),
        throwsA(new isInstanceOf<GameError>())
      );
    });
  });

  group('difference', () {
    final generator = _iterate(_sequence);

    test('between equal numbers', () {
      final game = Game(width: 5, height: 5, generator: generator);

      expect(game.difference, isNull);
      game.toggle(0, 0);
      expect(game.difference, equals(0));
      game.toggle(0, 1);
      expect(game.difference, equals(0));
      game.toggle(0, 2);
      expect(game.difference, equals(0));
      game.toggle(1, 0);
      expect(game.difference, isNull);
    });

    test('between nonequal numbers', () {
      final game = Game(width: 5, height: 5, generator: generator);

      expect(game.difference, isNull);
      game.toggle(0, 0);
      expect(game.difference, equals(0));
      game.toggle(4, 4);
      expect(game.difference, equals(4));
      game.toggle(2, 2);
      expect(game.difference, equals(2));
      game.toggle(1, 1);
      expect(game.difference, isNull);
      game.toggle(3, 3);
      expect(game.difference, equals(1));
    });
  });

  test('gameplay', () {
    final generator = _iterate(_sequence);
    final game = Game(width: 5, height: 5, minimum: 3, generator: generator);

    expect(game.preview, isNull);
    game.toggle(1, 1);
    expect(game.preview, isNull);
    game.toggle(3, 3);
    expect(game.preview, isNull);
    
    expect(
      () => game.play(),
      throwsA(new isInstanceOf<GameError>())
    );

    game.clear();
    
    expect(game.preview, isNull);
    game.toggle(0, 4);
    expect(game.preview, isNull);
    game.toggle(4, 0);
    expect(game.preview, isNull);
    game.toggle(2, 2);
    expect(game.preview.level, equals(1));
    expect(game.preview.moves, equals(2));
    expect(game.preview.score, equals(40));
    game.play();
    expect(game.level, equals(6));
    expect(game.moves, equals(8));
    expect(game.score, equals(40));
    game.toggle(2, 4);
    game.toggle(3, 4);
    game.toggle(4, 4);
    expect(game.preview.level, equals(0));
    expect(game.preview.moves, equals(-1));
    expect(game.preview.score, equals(5));
    game.play();
    expect(game.level, equals(6));
    expect(game.moves, equals(7));
    expect(game.score, equals(45));
  });
}

const _sequence = [
  1, 2, 3, 4, 5
];

Generator _iterate(List<int> numbers) {
  var i = 0;
  var l = numbers.length;

  return (_) => numbers[i++ % l];
}
