import 'package:flutter_test/flutter_test.dart';

import 'package:eyego_project/app.dart';

void main() {
  testWidgets('shows the Match point splash screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EyeGoApp());

    expect(find.text('Match point ;)'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 600));
  });
}
