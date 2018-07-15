import 'package:flutter/widgets.dart';
import 'game.dart';

class CellGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        color: const Color(0xFFFF0000)
      ),
    );
  }

}

class ScoreboardItem extends StatelessWidget {

  final int delta;
  final String label;
  final int value;

  ScoreboardItem({ this.delta, this.label, this.value });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("$label:"),
        Text("$value"),
        Text(delta != null ? "$delta" : ""),
      ],
    );
  }

}

class Scoreboard extends StatelessWidget {

  final int level;
  final int levelDelta;
  final int moves;
  final int movesDelta;
  final int score;
  final int scoreDelta;

  Scoreboard({ this.level, this.levelDelta, this.moves, this.movesDelta, this.score, this.scoreDelta });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          children: [
            ScoreboardItem(
              delta: levelDelta,
              label: "Level",
              value: level,
            ),
            ScoreboardItem(
              delta: movesDelta,
              label: "Moves",
              value: moves
            ),
            ScoreboardItem(
              delta: scoreDelta,
              label: "Score",
              value: score
            ),
          ],
        )
      ),
    );
  }

}

class GameWidget extends StatefulWidget {

  @override
  _GameWidgetState createState() => _GameWidgetState();

}

class _GameWidgetState extends State<GameWidget> {

  Game _game = Game();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: OrientationBuilder(
        builder: (context, orientation) {
          final panes = <Widget>[
            new CellGrid(),
            new Scoreboard(
              level: _game.level,
              levelDelta: _game.preview?.level,
              moves: _game.moves,
              movesDelta: _game.preview?.moves,
              score: _game.score,
              scoreDelta: _game.preview?.score,
            ),
          ];

          return orientation == Orientation.portrait
            ? Column(children: panes)
            : Row(children: panes);
        },
      ),
      color: Color(0xFFFFFFFF),
    );
  }

}
