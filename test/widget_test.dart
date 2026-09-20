import 'package:flutter_test/flutter_test.dart';

import 'package:eyego_project/app.dart';

void main() {
  testWidgets('shows the EyeGo splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const EyeGoApp());

    expect(find.text('EyeGo'), findsOneWidget);
  });
}
