import 'package:flutter/material.dart';
import 'package:goshops/presentation/style/style.dart';

class MakeGradientMask extends StatelessWidget {
  final Widget child;

  const MakeGradientMask({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            CustomStyle.bannerGradient1,
            CustomStyle.bannerGradient2,
          ],
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
