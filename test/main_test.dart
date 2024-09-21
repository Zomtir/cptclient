@Skip('Test are disabled because no HttpClient is offered atm')
library;

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cptclient/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App launch', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CptApp());
    await tester.pumpAndSettle();

    // Verify that the launched.
    expect(find.text('Reconnect'), findsOneWidget);
  });
}
