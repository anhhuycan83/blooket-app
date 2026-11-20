import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('App renders correctly test', (WidgetTester tester) async {
    await tester.pumpWidget(const BlooketLearnApp());
    expect(find.byType(BlooketLearnApp), findsOneWidget);
  });
}
