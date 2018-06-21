import 'package:flutter_test/flutter_test.dart';
import 'package:sequences/main.dart';

void main() {
  testWidgets('app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(new Application());

    expect(find.text('Sequences'), findsOneWidget);
  });
}
