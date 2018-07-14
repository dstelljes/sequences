import 'package:flutter_test/flutter_test.dart';
import 'package:sequences/game.dart';

void main() {
  group('initial state', () {
    test('0x0 board', () {
      final game = Game(width: 0, height: 0);

      expect(game.cells, hasLength(0));
      expect(game.score, equals(0));
      expect(game.selected, isEmpty);
    });

    test('2x2 board', () {
      final game = Game(width: 2, height: 2);
      expect(game.cells, hasLength(4));
    });
  });

  group('cell selection', () {
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

  group('hoofing', () {
    final generator = _iterate(_sequence);

    test('minimum length 1', () {
      final game = Game(width: 5, height: 5, minimum: 1, generator: generator);

      expect(game.canHoof, isFalse);
      game.toggle(0, 0);
      expect(game.canHoof, isTrue);
      game.toggle(0, 1);
      expect(game.canHoof, isTrue);
      game.toggle(0, 2);
      expect(game.canHoof, isTrue);
      game.toggle(1, 0);
      expect(game.canHoof, isFalse);
    });

    test('minimum length 3', () {
      final game = Game(width: 5, height: 5, minimum: 3, generator: generator);

      expect(game.canHoof, isFalse);
      game.toggle(0, 0);
      expect(game.canHoof, isFalse);
      game.toggle(2, 2);
      expect(game.canHoof, isFalse);
      game.toggle(4, 4);
      expect(game.canHoof, isTrue);
      game.toggle(1, 1);
      expect(game.canHoof, isFalse);
      game.toggle(3, 3);
      expect(game.canHoof, isTrue);
    });
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
