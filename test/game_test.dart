import 'package:flutter_test/flutter_test.dart';
import 'package:sequences/game.dart';

void main() {
  test('initial state', () {
    final game = Game(2, 2);

    expect(game.cells, hasLength(4));
    expect(game.score, equals(0));
    expect(game.selected, isEmpty);
  });

  test('cell selection', () {
    final game = Game(4, 4);

    expect(game.selected, hasLength(0));
    game.toggle(0);
    expect(game.selected, hasLength(1));
    game.toggle(0);
    expect(game.selected, hasLength(0));

    expect(
      () => game.toggle(16),
      throwsA(new isInstanceOf<GameError>())
    );
  });
}
