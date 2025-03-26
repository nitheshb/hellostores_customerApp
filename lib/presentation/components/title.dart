import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goshops/infrastructure/service/services.dart';

import 'package:goshops/presentation/style/style.dart';

import 'button/animation_button_effect.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final String? rightTitle;
  final String? subTitle;
  final VoidCallback? onTap;
  final Color titleColor;
  final double? titleSize;

  const TitleWidget({
    super.key,
    required this.title,
    this.rightTitle,
    this.subTitle,
    this.onTap,
    required this.titleColor,
    this.titleSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.r),
          child: Text(
            title,
            style: CustomStyle.interNoSemi(
              color: titleColor,
              size: titleSize ?? (AppHelpers.getType() == 3 ? 18 : 22),
            ),
          ),
        ),
        if (subTitle != null)
          Container(
            margin: EdgeInsets.only(left: 8.r,top: 1.5.r),
            padding: EdgeInsets.symmetric(vertical: 4.r, horizontal: 8.r),
            decoration: BoxDecoration(
              color: CustomStyle.red,
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Row(
              children: [
                Icon(
                  FlutterRemix.fire_fill,
                  color: CustomStyle.white,
                  size: 14.r,
                ),
                4.horizontalSpace,
                Text(
                  AppHelpers.getTranslation(subTitle!.toUpperCase()),
                  style: CustomStyle.interNoSemi(
                      color: CustomStyle.white, size: 10),
                )
              ],
            ),
          ),
        const Spacer(),
        if (rightTitle != null)
          ButtonEffectAnimation(
            onTap: () {
              onTap?.call();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.r, horizontal: 16.r),
              child: Text(
                AppHelpers.getTranslation(rightTitle ?? ''),
                style: CustomStyle.interNormal(
                    color: CustomStyle.seeAllColor, size: 14),
              ),
            ),
          ),
      ],
    );
  }
}
