import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_dimensions.dart';

class AppLogoBackground extends StatelessWidget {
  const AppLogoBackground({required this.child, super.key});

  static const _assetPath = 'assets/svgs/app_icon.svg';

  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      IgnorePointer(
        child: Center(
          child: Opacity(
            opacity: AppDimensions.logoBackgroundOpacity,
            child: SvgPicture.asset(
              _assetPath,
              width: AppDimensions.logoBackgroundSize,
              excludeFromSemantics: true,
            ),
          ),
        ),
      ),
      child,
    ],
  );
}
