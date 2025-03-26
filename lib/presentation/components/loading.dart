import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goshops/presentation/style/theme/theme_wrapper.dart';

import 'custom_progress_indicator.dart';

class Loading extends StatelessWidget {
  final bool changeColor;
  final double radius;

  const Loading({
    super.key,
    this.changeColor = false,
    this.radius = 5,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(builder: (colors, c) {
      return Center(
        child: JumpingDots(
          radius: radius,
          color: changeColor ? colors.white : colors.textBlack,
        ),
      );
    });
  }
}
