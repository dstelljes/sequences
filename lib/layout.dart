import 'package:flutter/widgets.dart';
import 'game.dart';

typedef void CellAction(int x, int y);

class Cell extends StatelessWidget {

  final GameCell cell;

  Cell({ this.cell });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "${cell.number}"
        ),
      ),
      color: cell.selected ? const Color(0xFFAAAAAA) : const Color(0xFFFFFFFF),
    );
  }

}

class CellGrid extends StatelessWidget {

  final List<GameCell> cells;
  final int height;
  final CellAction onTap;
  final int width;

  CellGrid({ this.cells, this.height, this.onTap, this.width });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        child: Column(
          children: List.generate(height, (y) =>
            Expanded(
              child: Row(
                children: List.generate(width, (x) =>
                  Expanded(
                    child: GestureDetector(
                      child: Cell(
                        cell: cells[y * width + x],
                      ),
                      onTap: () {
                        onTap(x, y);
                      },
                    ),
                  )
                ),
              ),
            ),
          ),
        )
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
            new CellGrid(
              cells: _game.cells,
              height: _game.height,
              onTap: (x, y) => setState(() {
                _game.toggle(x, y);
              }),
              width: _game.width
            ),
            new Scoreboard(
              level: _game.level,
              levelDelta: _game.preview?.level,
              moves: _game.moves,
              movesDelta: _game.preview?.moves,
              score: _game.score,
              scoreDelta: _game.preview?.score,
            ),
            new Row(
              children: [
                GestureDetector(
                  child: Text("Play"),
                  onTap: () => setState(() {
                    if (_game.preview != null) {
                      _game.play();
                    }
                  }),
                ),
                GestureDetector(
                  child: Text("Restart"),
                  onTap: () => setState(() {
                    _game = Game();
                  }),
                ),
              ]
            )
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
