import 'package:flutter/widgets.dart';

class BlockGrid extends StatelessWidget {

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

class Scoreboard extends StatelessWidget {
  
  @override
    Widget build(BuildContext context) {
      return Expanded(
        child: Center(
          child: Text(
            "Score",
          ),
        ),
      );
    }

}

class GameWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: OrientationBuilder(
        builder: (context, orientation) {
          final panes = <Widget>[
            new BlockGrid(),
            new Scoreboard(),
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
