import 'package:flutter/widgets.dart';
import 'package:sequences/layout.dart';

void main() => runApp(new Application());

class Application extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Directionality(
      child: DefaultTextStyle(
        child: GameWidget(),
        style: TextStyle(
          color: Color(0xFF000000),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
  }

}
