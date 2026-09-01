import 'package:flutter_test/flutter_test.dart';
import 'package:resume/main.dart';

void main() {
  testWidgets('Resume App renders successfully and loads default profile', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 2));

    // Verify that the default resume profile name is rendered.
    expect(find.text('Alexander Vance'), findsOneWidget);
    expect(find.text('Principal Interaction Engineer & Full-Stack Architect'), findsOneWidget);
  });
}
