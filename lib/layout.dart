import 'package:flutter/widgets.dart';
import 'game.dart';

const edgePadding = 24.0;

Color highlight(int number) {
  switch (number % 5) {
    case 1:
      return Color(0xFFD3E2B6);
    case 2:
      return Color(0xFFC3DBB4);
    case 3:
      return Color(0xFFAACCB1);
    case 4:
      return Color(0xFF87BDB1);
    default:
      return Color(0xFF68B3AF);
  }
}

typedef void CellCallback(int x, int y);

class Cell extends StatelessWidget {

  final GameCell cell;

  Cell({ this.cell });

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: FittedBox(
        child: SizedBox(
          child: Container(
            child: Center(
              child: Text(
                "${cell.number}",
                style: new TextStyle(
                  color: cell.selected ? Color(0xFFFFFFFF) : Color(0xFF000000),
                ),
              ),
            ),
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(Radius.circular(1.0)),
              color: cell.selected ? Color(0xFF444444) : highlight(cell.number)
            ),
          ),
          height: 25.0,
          width: 25.0,
        ),
      ),
      padding: EdgeInsets.all(edgePadding / 6),
    );
  }

}

class CellGrid extends StatelessWidget {

  final List<GameCell> cells;
  final int height;
  final CellCallback onToggle;
  final int width;

  CellGrid({ this.cells, this.height, this.onToggle, this.width });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Padding(
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
                          onToggle(x, y);
                        },
                      ),
                    )
                  ),
                ),
              ),
            ),
          )
        ),
        padding: EdgeInsets.all(edgePadding),
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
    return SafeArea(
      child: Container(
        child: OrientationBuilder(
          builder: (context, orientation) {
            final panes = <Widget>[
              new CellGrid(
                cells: _game.cells,
                height: _game.height,
                onToggle: (x, y) => setState(() {
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
      ),
    );
  }

}
