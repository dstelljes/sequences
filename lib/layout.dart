import 'package:flutter/widgets.dart';
import 'game.dart';

const buttonPadding = edgePadding / 2;
const cellPadding = edgePadding / 3;
const edgePadding = 12.0;

Color balance(int number) {
  if (number < 0)
    return Color(0xFFFF4136);

  if (number > 0)
    return Color(0xFF90EE90);

  return Color(0xFF888888);
}

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

String sign(int number) {
  return number < 0
    ? "$number"
    : "+$number";
}

typedef void CellCallback(int x, int y);

class Button extends StatelessWidget {

  final Widget child;
  final Color color;
  final VoidCallback onPress;
  final Color textColor;

  Button({ this.child, this.color, this.onPress, this.textColor });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Center(
          child: DefaultTextStyle(
            child: child,
            style: TextStyle(
              color: textColor
            ),
          ),
        ),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(Radius.circular(1.0)),
          color: color
        ),
        padding: EdgeInsets.all(buttonPadding),
      ),
      onTap: onPress,
    );
  }

}

class Cell extends StatelessWidget {

  final GameCell cell;
  final VoidCallback onToggle;

  Cell({ this.cell, this.onToggle });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        child: Button(
          child: Text("${cell.number}"),
          color: cell.selected ? Color(0xFF444444) : highlight(cell.number),
          onPress: onToggle,
          textColor: cell.selected ? Color(0xFFFFFFFF) : Color(0xFF000000),
        ),
        height: 28.0,
        width: 28.0,
      ),
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
      child: Container(
        child: Column(
          children: List.generate(height, (y) =>
            Expanded(
              child: Row(
                children: List.generate(width, (x) =>
                  Expanded(
                    child: Padding(
                      child: Cell(
                        cell: cells[y * width + x],
                        onToggle: () {
                          onToggle(x, y);
                        },
                      ),
                      padding: EdgeInsets.all(cellPadding),
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
    return Container(
      child: Row(
        children: [
          Container(
            child: Text(
              "$label:",
            ),
            width: 60.0,
          ),
          Expanded(
            child: Text(
              delta != null ? sign(delta) : "",
              style: TextStyle(color: balance(delta ?? 0)),
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            child: Text(
              "$value",
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
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
    return Column(
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
        child: Padding(
          child: OrientationBuilder(
            builder: (context, orientation) {
              final panes = <Widget>[
                Padding(
                  child: CellGrid(
                    cells: _game.cells,
                    height: _game.height,
                    onToggle: (x, y) => setState(() {
                      _game.toggle(x, y);
                    }),
                    width: _game.width
                  ),
                  padding: EdgeInsets.all(edgePadding - cellPadding)
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        child: FittedBox(
                          child: SizedBox(
                            child: Button(
                              child: Text("Play"),
                              color: _game.preview != null ? Color(0xFF000055) : Color(0xFFAAAAAA),
                              onPress: () => setState(() {
                                if (_game.preview != null) {
                                  _game.play();
                                }
                              }),
                            ),
                            width: 200.0,
                          ),
                          fit: BoxFit.fitWidth,
                        ),
                        padding: EdgeInsets.all(edgePadding),
                      ),
                      Expanded(
                        child: Padding(
                          child: FittedBox(
                            child: SizedBox(
                              child: Scoreboard(
                                level: _game.level,
                                levelDelta: _game.preview?.level,
                                moves: _game.moves,
                                movesDelta: _game.preview?.moves,
                                score: _game.score,
                                scoreDelta: _game.preview?.score,
                              ),
                              width: 200.0,
                            ),
                            fit: BoxFit.contain,
                          ),
                          padding: EdgeInsets.all(edgePadding),
                        )
                      ),
                      Padding(
                        child: FittedBox(
                          child: SizedBox(
                            child: Button(
                              child: Text("Restart"),
                              color: Color(0xFF90EE90),
                              onPress: () => setState(() {
                                _game = Game();
                              }),
                              textColor: Color(0xFF000000),
                            ),
                            width: 200.0,
                          ),
                          fit: BoxFit.contain,
                        ),
                        padding: EdgeInsets.all(edgePadding)
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                  ),
                ),
              ];

              return orientation == Orientation.portrait
                ? Column(children: panes)
                : Row(children: panes);
            },
          ),
          padding: EdgeInsets.all(edgePadding)
        ),
        color: Color(0xFFFFFFFF),
      ),
    );
  }

}
