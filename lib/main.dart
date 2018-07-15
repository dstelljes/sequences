import 'package:flutter/widgets.dart';
import 'package:sequences/layout.dart';

void main() => runApp(new Application());

class Application extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: Color(0xFFFF0000),
      initialRoute: '/',
      onGenerateRoute: generate,
      textStyle: TextStyle(
        color: Color(0xFF000000),
      ),
    );
  }

  Route generate(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return new PageRouteBuilder(
          pageBuilder: (context, animation, secondary) => GameWidget()
        );

      default:
        return null;
    }
  }

}
