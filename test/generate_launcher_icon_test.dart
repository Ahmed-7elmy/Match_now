import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the Match Point launcher icon source', (tester) async {
    await tester.pumpWidget(
      RepaintBoundary(
        child: SizedBox(
          width: 1024,
          height: 1024,
          child: SvgPicture.asset('assets/svgs/match_point_logo.svg'),
        ),
      ),
    );

    await expectLater(
      find.byType(RepaintBoundary),
      matchesGoldenFile('../assets/images/app_icon.png'),
    );
  });
}
