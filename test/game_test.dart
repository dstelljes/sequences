import 'package:flutter_test/flutter_test.dart';
import 'package:sequences/game.dart';

void main() {
  test('initial state', () {
    final game = Game();

    expect(Game.height, greaterThan(0));
    expect(Game.width, greaterThan(0));

    expect(game.cells, hasLength(Game.height * Game.width));
    expect(game.nextLevel, isFalse);
    expect(game.score, equals(0));
    expect(game.selected, isEmpty);
  });

  test('cell selection', () {
    final game = Game();

    expect(game.selected, hasLength(0));
    game.toggle(0);
    expect(game.selected, hasLength(1));
    game.toggle(0);
    expect(game.selected, hasLength(0));

    expect(
      () => game.toggle(Game.height * Game.width),
      throwsA(new isInstanceOf<GameError>())
    );
  });
}
