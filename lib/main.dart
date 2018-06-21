import 'package:flutter/material.dart';

void main() => runApp(new Application());

class Application extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text(
        'Sequences',
        textDirection: TextDirection.ltr,
      ),
    );
  }

}
